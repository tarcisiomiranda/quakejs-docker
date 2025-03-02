FROM debian:12

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install sudo curl git nodejs npm jq apache2 wget apt-utils python3 -y

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

# Fix mixed content
RUN git clone https://github.com/nerosketch/quakejs.git


WORKDIR /quakejs
COPY ./fix_mixed_content.py fix_mixed_content.py
RUN python3 fix_mixed_content.py

RUN npm install
RUN ls
COPY server.cfg /quakejs/base/baseq3/server.cfg
COPY server.cfg /quakejs/base/cpma/server.cfg
# The two following lines are not necessary because we copy assets from include.  Leaving them here for continuity.
# WORKDIR /var/www/html
# RUN bash /var/www/html/get_assets.sh
COPY ./include/ioq3ded/ioq3ded.fixed.js /quakejs/build/ioq3ded.js

RUN rm /var/www/html/index.html && cp /quakejs/html/* /var/www/html/
COPY ./include/assets/ /var/www/html/assets
RUN ls /var/www/html


WORKDIR /
ADD entrypoint.sh /entrypoint.sh
# Was having issues with Linux and Windows compatibility with chmod -x, but this seems to work in both
RUN chmod 777 ./entrypoint.sh

EXPOSE 27960
EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
