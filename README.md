# UART Communication System using Verilog HDL

## Overview

This project implements an 8-bit UART (Universal Asynchronous Receiver/Transmitter) communication system using Verilog HDL. The design includes a baud rate generator, UART transmitter, UART receiver, top-level integration module, and a simulation testbench.

The design was developed and simulated using Xilinx Vivado.

## Features

- 8-bit UART data transmission and reception
- Asynchronous serial communication
- Configurable baud-rate generation
- FSM-based UART transmitter
- FSM-based UART receiver
- Start-bit and stop-bit detection
- Receiver sampling for reliable data reception
- Busy status indication during transmission
- Ready (`rdy`) indication after successful reception
- Reset and ready-clear control
- Verilog-based simulation testbench

## System Architecture

```text
                    +----------------------+
                    |  Baud Rate Generator |
                    +----------+-----------+
                               |
                    +----------+----------+
                    |                     |
                 TX Enable            RX Enable
                    |                     |
                    v                     v
             +-------------+       +-------------+
             | UART        |       | UART        |
             | Transmitter |------>| Receiver    |
             +-------------+  TX   +-------------+
                    |                     |
                    |                     |
                 TX Serial            Received
                   Data                 Data
                    |                     |
                    +---------+-----------+
                              |
                         UART Top Module



