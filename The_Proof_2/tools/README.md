Here's the tools and information used to create this challenge. 

Here's the flag:
Flag{Which_problem_is_the_hard_one?}

Here's how to extract it:
steghide extract -sf filename.jpg
(hit enter to use a blank password)
(the flag is saved in a file named stegflag.txt)

Here's how I created it:
create a file stegflag.txt with the flag in it
steghide embed -ef stegflag.txt -cf CCF25082020_3.jpg -sf CCF25082020_3_flagged.jpg
hit enter twice to use a blank password

The files are transmitted back to back, separated by a poem, in a short code spread spectrum signal. 

There is a hint about the spreading code. 

There were some strange errors with this challenge creation that we want to come back to. Originally, we wanted to send the three .jpg files as three CDMA signals, separated by different codes. Trying to insert a common synchronization word didn't work. We dropped back to a single signal with the files sent one after another. 

binwalk, or something similar, will be very useful to separate out the files from the demodulated and decoded data. 

The preamble text file and the image files were packaged together using cat, then sent by the transmitter. The preamble was 
first, then image 1, then preamble, then image 2, then preamble, then image 3, then preamble. 
