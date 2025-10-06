#!/bin/bash

play_beeps0() {
  for i in {1..2}
  do
    play -q -n synth 0.8 sine 1000 vol 0.6
    sleep 0.33
  done
}


play_beeps1() {
  for i in {1..2}
  do
    play -q -n synth 0.08 sine 1200 vol 0.5
    sleep 0.07
  done
}


play_beeps2() {
  for i in {1..2}
  do
    play -q -n synth 0.15 sine 1000 vol 0.6
    sleep 0.1
  done
}


play_beeps3() {
  for i in {1..2}
  do
    play -q -n synth 0.12 square 1100 vol 0.4
    sleep 0.1
  done
}


play_beeps4() {
  for i in {1..2}; do
    play -q -n synth 0.12 sine 1000 fade 0.005 0.12 0.02 vol -6dB
    sleep 0.15
  done
}


play_beeps5() {
  play -q -n synth 0.12 sine 1000 fade 0.005 0.12 0.02 vol -6dB pad 0 0.15 repeat 1
}


play_beeps6() {
  play -q -n synth 0.10 sine 900-1300 fade 0.005 0.10 0.02 vol -6dB pad 0 0.12 repeat 1
}

play_beeps7() {
  play -q -n synth 0.10 sine 1000 fade 0.005 0.10 0.02 vol -6dB
  sleep 0.12
  play -q -n synth 0.10 sine 1300 fade 0.005 0.10 0.02 vol -6dB
}

play_beeps5
