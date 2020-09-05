%This script generates the entire message, including BCH1 and BCH2 fields,
%for the 406MHz digital personal locator beacon signal. 

%for our game, 13 bursts are sent, each with a doppler added in 
%GNU Radio. Each beacon burst has a *different* GPS location!

%Where is the signal really coming from?

%BCH-1 is the first BCH code of the long format 406 MHz emergency beacon

%first, we do the BCH-1 example, from the technical document
%Paul noticed that the polynomial order is reversed in gfdecov function.
%That is why we used the fliplr function, and swapped the padding.

bch1_msg = [0 1 0 1 0 1 1 0 1 1 1 0 0 1 1 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 ...
    0 0 1 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1];
zero_padding1 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
leading_zeros1 = [0 0 0 0 0 0 0 0 0 0 ...
    0 0 0 0 0 0 0 0 0 0 ...
    0 0 0 0 0 0 0 0 0 0 ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

gx1 = [1 0 0 1 1 0 1 1 0 1 1 0 0 1 1 1 1 0 0 0 1 1];

gx1 = fliplr(gx1);


msg1 = [zero_padding1 fliplr(bch1_msg) leading_zeros1];

[q1,r1] = gfdeconv(msg1,gx1);

r1;

flipped_r1 = [ 0 0 fliplr(r1)];

%matches answer below from document

[0 0 1 0 1 1 0 0 1 0 1 0 1 0 1 0 0 1 0 0 1];

%Next we do the BCH-2 example from the technical documentation.

bch2_msg = [1 0 0 1 0 1 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 0 1 1 1];
zero_padding2 = [0 0 0 0 0 0 0 0 0 0 0 0];
leading_zeros2 = [0 0 0 0 0 0 0 0 0 0 ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

gx2 = [1 0 1 0 1 0 0 1 1 1 0 0 1];

gx2 = fliplr(gx2);


msg2 = [zero_padding2 fliplr(bch2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2,gx2);

r2;

flipped_r2 = [0 0 0 fliplr(r2)];

%matches answer below from document

[0 0 0 1 0 1 0 1 0 0 0 1];


%BCH1 can correct up to 3 errors
%BCH2 can correct up to 2 errors

%so we should make sure there are some errors in there at the end.

%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

%Now that we have some math that works, use this to create
%the messages in the CTF.

%We are using the GPS coordinates in the messages to make a set of 
%"impossible" locations. 

%here are all the fields that stay the same.

bit_sync = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %15 bits

frame_sync = [0 0 0 1 0 1 1 1 1]; %9 bits

%follows is the PDF1 (protected data field 1) 61 bits total

protocol = [1 1]; %2 bits

country_code = [0 1 0 1 0 1 0 0 1 0]; %10 bits

serial_user = [0 1 1 1 1 0 0]; %7 bits

serial_number = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %20 bits

other_data = [1 0 1 0 0 1 1 0 1 0]; %666 could be important %10 bits

cs_cert = [0 0 0 0 0 0 0 0 0 0]; %10 bits

radio_location = [0 1]; %121.5 MHz beacon used %2 bits
        
%BCH1 goes here

%all location fields go here

%BCH2 field goes here %21 bits

%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


%here are the fields that change per packet


% position_data_source = [0]
% 
% location_N = [0]
% 
% location_N_degrees = []
% 
% location_N_minutes = [0 1 1 1 1 1 1 1 0 0 0 0]  %default value
% 
% location_W = [1]
% 
% location_W_degrees = []
% 
% location_W_minutes = [0 1 1 1 1 1 1 1 1 0 0 0 0]
%
% % location information is the PDF2
% 
% %construct the BCH2-msg here
% 
% BCH2 = []





%construct the BCH1-msg here from protocol country_code
%serial_user serial_number other_data cs_cert radio_location

BCH1_msg = [protocol country_code serial_user serial_number other_data ...
    cs_cert radio_location];

msg1_sd = [zero_padding1 fliplr(BCH1_msg) leading_zeros1];

[q1,r1] = gfdeconv(msg1_sd,gx1);

r1;

flipped_r1 = [ 0 0 0 fliplr(r1)];

BCH1 = flipped_r1;

%BCH1 stays the same for all messages.

%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%San Diego 32 52 N, 117 16 W
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [0];

location_N = [0]; 

location_N_degrees = [0 1 0 0 0 0 0]; %7 bits

location_N_minutes = [1 1 0 1]; %4 minute accuracy; use table

location_W = [1];

location_W_degrees = [0 1 1 1 0 1 0 1]; %8 bits

location_W_minutes = [0 1 0 0]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_sd = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_sd,gx2);

r2;

flipped_r2 = [0 0 0 0 fliplr(r2)];


BCH2 = flipped_r2;



%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_sd = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_sd);


%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
















%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%Crack in the Ground 43 20 N, 120 40 W
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [1];

location_N = [0]; 

location_N_degrees = [0 1 0 1 0 1 1]; %7 bits

location_N_minutes = [0 1 0 1]; %4 minute accuracy; use table

location_W = [1];

location_W_degrees = [0 1 1 1 1 0 0 0]; %8 bits

location_W_minutes = [1 0 1 0]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_citg = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_citg,gx2);

r2;

flipped_r2 = [0 fliplr(r2)];


BCH2 = flipped_r2;



%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_citg = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_citg);








%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%ESA near Madrid, Spain 40 26 N, 3 57 W
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [0];

location_N = [0]; 

location_N_degrees = [0 1 0 1 0 0 0]; %7 bits

location_N_minutes = [0 1 1 0]; %4 minute accuracy; use table

location_W = [1];

location_W_degrees = [0 0 0 0 0 0 1 1]; %8 bits

location_W_minutes = [1 1 1 0]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_madrid = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_madrid,gx2);

r2;

flipped_r2 = [fliplr(r2)];


BCH2 = flipped_r2;

%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_madrid = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_madrid);










%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%Stonehenge 51 11 N, 1 50 W
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [0];

location_N = [0]; 

location_N_degrees = [0 1 1 0 0 1 1]; %7 bits

location_N_minutes = [0 0 1 1]; %4 minute accuracy; use table

location_W = [1];

location_W_degrees = [0 0 0 0 0 0 0 1]; %8 bits

location_W_minutes = [1 1 0 0]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_stone = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_stone,gx2);

r2;

flipped_r2 = [0 fliplr(r2)];


BCH2 = flipped_r2;

%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_stone = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_stone);






%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%Forbidden City 39 55 N, 116 23 E
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [0];

location_N = [0]; 

location_N_degrees = [0 1 0 0 1 1 1]; %7 bits

location_N_minutes = [1 1 1 0]; %4 minute accuracy; use table

location_W = [0];

location_W_degrees = [0 1 1 1 0 1 0 0]; %8 bits

location_W_minutes = [0 1 1 0]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_for = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_for,gx2);

r2;

flipped_r2 = [fliplr(r2)];


BCH2 = flipped_r2;

%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_for = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_for);







%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%Arecibo 18 21 N, 66 45 W
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [0];

location_N = [0]; 

location_N_degrees = [0 0 1 0 0 1 0]; %7 bits

location_N_minutes = [0 1 0 1]; %4 minute accuracy; use table

location_W = [1];

location_W_degrees = [0 1 0 0 0 0 1 0]; %8 bits

location_W_minutes = [1 0 1 1]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_are = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_are,gx2);

r2;

flipped_r2 = [fliplr(r2)];


BCH2 = flipped_r2;

%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_are = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_are);






%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%Maunakea 19 50 N, 155 28 W
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [0];

location_N = [0]; 

location_N_degrees = [0 0 1 0 0 1 1]; %7 bits

location_N_minutes = [1 1 0 0]; %4 minute accuracy; use table

location_W = [1];

location_W_degrees = [1 0 0 1 1 0 1 1]; %8 bits

location_W_minutes = [0 1 1 1]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_kea = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_kea,gx2);

r2;

flipped_r2 = [0 fliplr(r2)];


BCH2 = flipped_r2;

%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_kea = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_kea);





%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%Grand Shrine, Japan 35 24 N, 132 41 E
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [0];

location_N = [0]; 

location_N_degrees = [0 1 0 0 0 1 1]; %7 bits

location_N_minutes = [0 1 1 0]; %4 minute accuracy; use table

location_W = [0];

location_W_degrees = [1 0 0 0 0 1 0 0]; %8 bits

location_W_minutes = [1 0 1 0]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_grand = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_grand,gx2);

r2;

flipped_r2 = [0 0 fliplr(r2)];


BCH2 = flipped_r2;

%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_grand = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_grand);






%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%Nabta Playa 22 32 N, 30 42 E
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [0];

location_N = [0]; 

location_N_degrees = [0 0 1 0 1 1 0]; %7 bits

location_N_minutes = [1 0 0 0]; %4 minute accuracy; use table

location_W = [0];

location_W_degrees = [0 0 0 1 1 1 1 0]; %8 bits

location_W_minutes = [1 0 1 0]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_nab = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_nab,gx2);

r2;

flipped_r2 = [0 fliplr(r2)];


BCH2 = flipped_r2;

%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_nab = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_nab);






%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%Chinchurro, Atacama, Camerones Valley 19 01 S, 69 52 W
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [0];

location_N = [1]; 

location_N_degrees = [0 0 1 0 0 1 1]; %7 bits

location_N_minutes = [0 0 0 0]; %4 minute accuracy; use table

location_W = [1];

location_W_degrees = [0 1 0 0 0 1 0 1]; %8 bits

location_W_minutes = [1 1 0 1]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_chin = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_chin,gx2);

r2;

flipped_r2 = [0 0 0 fliplr(r2)];


BCH2 = flipped_r2;

%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_chin = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_chin);




%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%Amundsen-Scott, brrrrr 85 06 S, 0 0 E
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [0];

location_N = [1]; 

location_N_degrees = [1 0 1 0 1 0 1]; %7 bits

location_N_minutes = [0 0 1 0]; %4 minute accuracy; use table

location_W = [0];

location_W_degrees = [0 0 0 0 0 0 0 0]; %8 bits

location_W_minutes = [0 0 0 0]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_brr = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_brr,gx2);

r2;

flipped_r2 = [fliplr(r2)];


BCH2 = flipped_r2;

%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_brr = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_brr);






%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%Carkeek Observatory 41 09 S, 175 20 E
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [0];

location_N = [1]; 

location_N_degrees = [0 1 0 1 0 0 1]; %7 bits

location_N_minutes = [0 0 1 0]; %4 minute accuracy; use table

location_W = [0];

location_W_degrees = [1 0 1 0 1 1 1 1]; %8 bits

location_W_minutes = [0 1 0 1]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_car = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_car,gx2);

r2;

flipped_r2 = [fliplr(r2)];


BCH2 = flipped_r2;

%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_car = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_car);






%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%Abastumani Observatory 41 45 N, 42 49 E
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

position_data_source = [0];

location_N = [0]; 

location_N_degrees = [0 1 0 1 0 0 1]; %7 bits

location_N_minutes = [1 0 1 1]; %4 minute accuracy; use table

location_W = [0];

location_W_degrees = [0 0 1 0 1 0 1 0]; %8 bits

location_W_minutes = [1 1 0 0]; %4 minute accuracy; use table

%construct the BCH2-msg here from location_N location_N_degrees ...
%location_N_minutes location_W location_W_degrees location_W_minutes

BCH2_msg = [position_data_source location_N location_N_degrees ...
    location_N_minutes location_W location_W_degrees location_W_minutes];

msg2_aba = [zero_padding2 fliplr(BCH2_msg) leading_zeros2];

[q2,r2] = gfdeconv(msg2_aba,gx2);

r2;

flipped_r2 = [0 fliplr(r2)];


BCH2 = flipped_r2;

%Here is where we construct a full packet. 
%message = [bit_sync frame_sync protocol country_code serial_user ...
%serial_number other_data cs_cert radio_location BCH1_msg ...
%GPS_device location_N location_N_degrees location_N_minutes ...
%location_W location_W_degrees location_W_minutes BCH2_msg]

message_aba = [bit_sync frame_sync protocol country_code serial_user ...
serial_number other_data cs_cert radio_location BCH1 ...
position_data_source location_N location_N_degrees location_N_minutes ...
location_W location_W_degrees location_W_minutes BCH2]

length(message_aba);






