#!/bin/sh

git clone https://bit.adguard.com/scm/adguard-filters/dns-resolvers.git

cp dns-resolvers/output/providers.json ../AdguardExtension/AdguardApp/providers.json

rm -rf dns-resolvers