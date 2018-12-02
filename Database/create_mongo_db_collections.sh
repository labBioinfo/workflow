#!/usr/bin/env bash

mongo
use labbioinfo
db.createCollection("AG")
db.createCollection("T2D")
db.createCollection("IBD")

