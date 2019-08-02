#!/bin/sh

(cd ../../fakerco-terraform-state && \
    git pull origin master) && \
        terraform $@

(cd ../../fakerco-terraform-state && \
    git add . && \
    git commit -m "[terraform] update state" && \
    git push origin master)
