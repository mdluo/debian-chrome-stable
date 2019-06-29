FROM debian:stable-slim

RUN apt-get update && apt-get install -y gnupg wget

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install --no-install-recommends -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /usr/local/bin/dumb-init
ENTRYPOINT ["dumb-init", "--"]

EXPOSE 9229
VOLUME /.local
VOLUME /.pki
USER 1000

CMD ["bash", "-c", "google-chrome --version \
  && exec google-chrome \
    --disable-background-networking \
    --disable-default-apps \
    --disable-extensions \
    --disable-features=NetworkService \
    --disable-gpu \
    --disable-sync \
    --disable-translate \
    --headless \
    --hide-scrollbars \
    --metrics-recording-only \
    --mute-audio \
    --no-first-run \
    --no-sandbox \
    --no-zygote \
    --remote-debugging-address=0.0.0.0 \
    --remote-debugging-port=9229 \
    --safebrowsing-disable-auto-update"]
