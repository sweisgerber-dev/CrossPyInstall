#!/usr/bin/env bash
gpg --keyserver keys.gnupg.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
gpg --armor --export B42F6819007F00F88E364FD4036A9C25BF357DD4 > res/gosu.gpg
