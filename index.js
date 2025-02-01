const puppeteer = require('puppeteer-core');
const fs = require('fs');

scrapeYouTubeData('aqz-KE-bpKQ').then(() => console.log('[scrape-youtube-termux] Fetch started..'));

async function scrapeYouTubeData(videoId) {
  const browser = await puppeteer.launch({
    headless: "new",
    args: [
      "--no-sandbox",
      "--disable-gpu",
    ],
    executablePath:"/usr/bin/chromium"
  });
  const responseJsonFile = './response.json';

  try {
    // Start a new page
    const page = await browser.newPage();

    // Turn on Chrome DevTools
    const client = await page.createCDPSession();
    await client.send("Debugger.enable");
    await client.send("Debugger.setAsyncCallStackDepth", { maxDepth: 32 });
    await client.send("Network.enable");

    // Intercept the requestWillBeSent event
    client.on("Network.requestWillBeSent", (e) => {
      if (e.request.url.includes("/youtubei/v1/player")) {
        const jsonData = JSON.parse(e.request.postData);
        const poToken = `${jsonData["serviceIntegrityDimensions"]["poToken"]}`;
        const visitorData = `${jsonData["context"]["client"]["visitorData"]}`;

        // Extract and log PO Token and visitor data
        console.log(`PO_TOKEN: ${poToken}`);
        console.log(`VISITOR_DATA: ${visitorData}`);

        // Save PO Token and visitor data to json
        const responseJson = JSON.parse(fs.readFileSync(responseJsonFile, 'utf8'));

        responseJson.poToken = poToken
        responseJson.visitorData = visitorData

        fs.writeFileSync(responseJsonFile, JSON.stringify(responseJson));

        // Close the browser
        browser.close();
      }
    });

    // Go to the YouTube embed URL
    await page.goto("https://www.youtube.com/embed/" + videoId, {
      waitUntil: "networkidle2",
    });

    // Start playing the video
    const playButton = await page.$("#movie_player");
    await playButton.click();
  } catch (error) {
    console.error("Error scraping YouTube data:", error);
    await browser.close();
  }
}
