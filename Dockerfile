FROM ruby:3.0.4-bullseye
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    autoconf \
    libtool \
    libde265-dev \
    libdjvulibre-dev \
    libfftw3-dev \
    libghc-bzlib-dev \
    libgraphviz-dev \
    libgs-dev \
    libheif-dev \
    libmagickcore-dev \
    libjbig-dev \
    libjemalloc-dev \
    libjpeg-dev \
    libturbojpeg0-dev \
    liblcms2-dev \
    liblqr-1-0-dev \
    liblzma-dev \
    libopenexr-dev \
    libpng-dev \
    libraqm-dev \
    libtiff-dev \
    libwebp-dev \
    libwmf-dev \
    libzstd-dev \
    wget \
    less \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/
# ImageMagick 7 のインストール
#
# 参考:
# - 手順: https://www.tecmint.com/install-imagemagick-on-debian-ubuntu/
# - バージョン: https://imagemagick.org/archive/releases/
# - heic対応: https://www.joelotz.com/blog/2022/building-imagemagick-71-with-heic-support-from-source.html

RUN wget https://github.com/ImageMagick/ImageMagick/archive/refs/tags/7.1.1-9.tar.gz && \
    tar xzf 7.1.1-9.tar.gz && \
    cd ImageMagick-7.1.1-9 && \
    ./configure \
      --with-heic=yes \
      --with-jpeg=yes \
      --with-png=yes \
      --with-tiff=yes \
      --with-openjp2=yes && \
    make && \
    make install && \
    ldconfig /usr/local/lib/ && \
    convert -version && \
    cd .. && \
    rm -rf ImageMagick-7.1.1-9 7.1.1-9.tar.gz

# 必要なライブラリのインストール
RUN apt-get update && apt-get install -y libpq-dev npm nodejs && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    curl -L https://install.meilisearch.com | sh && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /myapp

# 先にpackage.jsonとpackage-lock.jsonをコピー
COPY package*.json ./
RUN npm install

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local path 'vendor/bundle' && bundle install
COPY . .
