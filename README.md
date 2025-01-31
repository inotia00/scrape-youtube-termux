## How to Run Scrape-YouTube-Termux

### 1. Install Termux

[Termux Official](https://github.com/termux/termux-app/releases/latest)

[Termux Monet (Deprecated)](https://github.com/Termux-Monet/termux-monet/releases/latest)

### 2. Install Scrape-YouTube-Termux

First, run termux and type the following command:

```
curl -sLo pot.sh https://raw.githubusercontent.com/inotia00/scrape-youtube-termux/main/scrape-youtube.sh && chmod +x pot.sh && curl -sLo container.sh https://raw.githubusercontent.com/inotia00/scrape-youtube-termux/main/install-alpine.sh && chmod +x container.sh && ./container.sh
```

Alpine Linux will be installed and run.

If Alpine Linux is running, type the following command:

```
sh pot.sh
```

Scrape-YouTube will run, and PO Token and visitor data will be output:

```bash
PO_TOKEN: <PO_TOKEN_HERE>
VISITOR_DATA: <VISITOR_DATA_HERE>
```

### 3. Run Scrape-YouTube-Termux

If Scrape-YouTube-Termux is already installed, you can use the following commands.

Run Alpine Linux:

```
container
```

Run Scrape-YouTube:

```
sh pot.sh
```

## References

Scrap-YouTube-Termux has brought the core feature of both repository:

* [Scrape-YouTube](https://github.com/fsholehan/scrape-youtube)
: Main source of the Scrap-YouTube-Termux.

* [Puppeteer-On-Termux](https://github.com/sarowarhosen03/puppeteer-on-termux)
: Package for running Puppetier on Termux.
