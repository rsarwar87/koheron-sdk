set -e

python scripts/make.py --test

for instrument in led_blinker adc_dac pulse_generator oscillo spectrum
do
    make NAME=$instrument server
done
