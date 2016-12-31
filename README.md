# LS193-Binary-Counters-SN74LS193N-
Work for designs with standard ICs using Verilog for prototyping
## Challenge
1. UP and DOWN are edge sensitive for both posedge and negedge for CO_Bar and BO_Bar, work around: use QD to pull up
2. UP and DOWN are posedge triggering, but "active low" (still active high as data changes when UP/DOWN is high), they are default to be high. Work arround, use a mode reg to follow the negedge and determin if we are in UP mode (1) or DOWN mode (0).
3. Count both UP and DOWN is undefined behavior, and not so useful. I simulated as keep the old mode, need to try with the device, maybe a racing.
4. No delay was imposed here as it is rated about 25Mhz and delays are only less than 50ns.
