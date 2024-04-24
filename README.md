# LTS

Laser Tunning Software

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Older Versions](#older-versions)
- [Versions Hierarchy](#versions-hierarchy)
- [Deployment](#deployment)

## Prerequisites

* Python 3.6.8

## Installation

* `pip install -r requirements.txt`

## Usage

* `python main.py`

## Older Versions

Check the other branches.

## Versions Hierarchy
```
CT3-2022-V1.12
├── CT3-2022-V1.12T
│   └── CT3-2022-V1.13T-INT
├── CT3-2022-V1.12H6
└── CT3-2022-V1.12-INT
```
```
CT3-2022-V1.11~
├── CT3-2022-V1.11l
└── CT3-2022-V1.11H6
    └── CT3-2022-V1.11H6.1
```
```
CF3-2022-V1.8
```

## Deployment
Example code to make one file executable with obfuscated Python files.
```
pyarmor pack --name "CT3-2022-V1.12" -e " --windowed --onefile --add-data "Control.qml;." --add-data "chilas.png;." --icon "icon.ico" --add-data "icon.ico;." --add-data "main.qml;." --add-data "PageCntrlPnl.qml;." --add-data "PageScan.qml;." --add-data "Splash.qml;."" main.py
```
