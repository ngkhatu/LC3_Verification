In this email i attached the LC3 Microcontroller files 

-   *.vp protected files are the MCU stages coded in SystemVerilog. 
-   TopLevelLC3.v is the top DUT file than encompasses the whole design ( all the pipeline stages are instantiated and connected in this file). 

This is a clean DUT. you will use it to design a testbench matching its functionality.

So if you designed your Testbench correctly you should not get any bugs or error messages. 

Later I will send you couple files that make the DUT buggy and tell you exactly what kind of bug each file gives you so you can verify if your Testbench is catching the bugs correctly. 

When you are confident that your testbench is doing his job correctly, i will send a set of 5 unknown bugs and your team should find what those bugs are and write a report about them ( more detailed email about the report will be send to you in the proper time , don't worry about it right know).
