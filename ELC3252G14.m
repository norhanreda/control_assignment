clc;
% clear;
close all;
m1=100;
m2=100;
k1=5;
k2=50;
k3=5;
f1=100;
f2=100;


[ess1,ess2,s1,tf1,wn1,z1]=x1(m1,m2,k1,k2,k3,f1,f2);
[ess7,s7,tf7,wn7,z7]=req_6_7(m1,m2,k1,k2,k3,f1,f2);
[ess1_1,s1_1,tf1_1,wn1_1,z1_1]=req_8(1,m1,m2,k1,k2,k3,f1,f2);
[ess1_10,s1_10,tf1_10,wn1_10,z1_10]=req_8(10,m1,m2,k1,k2,k3,f1,f2);
[ess1_100,s1_100,tf1_100,wn1_100,z1_100]=req_8(100,m1,m2,k1,k2,k3,f1,f2);
[ess1_1000,s1_1000,tf1_1000,wn1_1000,z1_1000]=req_8(1000,m1,m2,k1,k2,k3,f1,f2);
% req9
[ess9_1,s9_1,tf9_1,wn9_1,z9_1]=req_9(4189.5,m1,m2,k1,k2,k3,f1,f2);
% [ess9_10,s9_10,tf9_10,wn9_10,z9_10]=req_9(1,m1,m2,k1,k2,k3,f1,f2);
% [ess9_100,s9_100,tf9_100,wn9_100,z9_100]=req_9(100,m1,m2,k1,k2,k3,f1,f2);
% [ess9_1000,s9_1000,tf9_1000,wn9_1000,z9_1000]=req_9(1000,m1,m2,k1,k2,k3,f1,f2);
% req10
[ess10,s10,tf10,wn10,z10]=req_10(5,100,m1,m2,k1,k2,k3,f1,f2);


%X1%
function [ess1,ess2,s,tf1,wn,z] =  x1(m1,m2,k1,k2,k3,f1,f2)
B1 = tf(k1,1);
B2 = tf(k2,1);
B3 = tf([f1,0],1);
B4 = tf(1,[m1,0,0]);
B5 = tf(k3,1);
B6 = tf([f2,0],1);
B7 = tf([m2,0,0],1);
B8 = tf(k2,1);
B9 = tf(1,k2);
B10 =tf(k2,1);

BlockMat = append(B1,B2,B3,B4,B5,B6,B7,B8,B9,B10);

connect_map =[1, 4, 0, 0,0; ... 
 2, 4, 0, 0,0; ...
 3, 4, 0, 0,0; ...
 4, -1, -2, -3,10; ...
 5,9, 0, 0,0; ...
 6,9, 0, 0,0; ...
 7,9, 0, 0,0; ...
 8,4, 0, 0,0; ...
 9,-5, -6, -7,8; ...
 10,9, 0, 0,0; ...

];
input_loc = 4; 
output_loc = [4,9]; 


sys=connect(BlockMat,connect_map,input_loc,output_loc);
figure();
p=stepplot(sys);
% figure();
setoptions(p,'RiseTimeLimits',[0,1]);
s=stepinfo(sys);
tf1=tf(sys);
% print(TF)
figure();
pzmap(tf1(1));
[wn,z]=damp(sys);
figure();
pzmap(tf1(2));
[wn1,z1]=damp(sys);
SP=1; %input value, if you put 1 then is the same as step(sys)
[y,t]=step(SP*tf1(1)); %get the response of the system to a step with amplitude SP
ess1=abs(SP-y(end)) %get the steady state error
SP=1; %input value, if you put 1 then is the same as step(sys)
[y,t]=step(SP*tf1(2)); %get the response of the system to a step with amplitude SP
ess2=abs(SP-y(end)) %get the steady state error
end

function [ess,s,tf1,wn,z] =  req_6_7(m1,m2,k1,k2,k3,f1,f2)
B1 = tf(k1,1);
B2 = tf(k2,1);
B3 = tf([f1,0],1);
B4 = tf(1,[m1,0,0]);
B5 = tf(k3,1);
B6 = tf([f2,0],1);
B7 = tf([m2,0,0],1);
B8 = tf(k2,1);
B9 = tf(1,k2);
B10 =tf(k2,1);


BlockMat = append(B1,B2,B3,B4,B5,B6,B7,B8,B9,B10);

connect_map =[1, 4, 0, 0,0,0; ... 
 2, 4, 0, 0,0,0; ...
 3, 4, 0, 0,0,0; ...
 4, -1, -2, -3,10,-9; ...
 5,9, 0, 0,0,0; ...
 6,9, 0, 0,0,0; ...
 7,9, 0, 0,0,0; ...
 8,4, 0, 0,0,0; ...
 9,-5, -6, -7,8,0; ...
 10,9, 0, 0,0,0; ...

];
input_loc = 4; 
output_loc = [4,9]; 


sys=connect(BlockMat,connect_map,input_loc,output_loc);
figure();
tf1=tf(sys);
% figure();
opt=stepDataOptions('InputOffset',0,'StepAmplitude',2);
p=stepplot(tf1(2),opt);
setoptions(p,'RiseTimeLimits',[0,1]);
s=stepinfo(tf1(2));
SP=2; %input value, if you put 1 then is the same as step(sys)
[y,t]=step(SP*tf1(2)); %get the response of the system to a step with amplitude SP
ess=abs(SP-y(end)) %get the steady state error
% print(TF)
figure();
pzmap(tf1(2));
[wn,z]=damp(tf1(2));
% figure();
% pzmap(tf1(2));
% [wn1,z1]=damp(sys);

end

function [ess,s,tf1,wn,z] =  req_8(kp,m1,m2,k1,k2,k3,f1,f2)
B1 = tf(k1,1);
B2 = tf(k2,1);
B3 = tf([f1,0],1);
B4 = tf(1,[m1,0,0]);
B5 = tf(k3,1);
B6 = tf([f2,0],1);
B7 = tf([m2,0,0],1);
B8 = tf(k2,1);
B9 = tf(1,k2);
B10 =tf(k2,1);
B11=tf(kp,1);

BlockMat = append(B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11);

connect_map =[1, 4, 0, 0,0,0; ... 
 2, 4, 0, 0,0,0; ...
 3, 4, 0, 0,0,0; ...
 4, -1, -2, -3,10,11; ...
 5,9, 0, 0,0,0; ...
 6,9, 0, 0,0,0; ...
 7,9, 0, 0,0,0; ...
 8,4, 0, 0,0,0; ...
 9,-5, -6, -7,8,0; ...
 10,9, 0, 0,0,0; ...
 11,-9, 0, 0,0,0; ...

];
input_loc = 11; 
output_loc = [4,9]; 


sys=connect(BlockMat,connect_map,input_loc,output_loc);
figure();
tf1=tf(sys);
% figure();
opt=stepDataOptions('InputOffset',0,'StepAmplitude',2);
p=stepplot(tf1(2),opt);
setoptions(p,'RiseTimeLimits',[0,1]);
s=stepinfo(tf1(2));
SP=2; %input value, if you put 1 then is the same as step(sys)
[y,t]=step(SP*tf1(2)); %get the response of the system to a step with amplitude SP
ess=abs(SP-y(end)) %get the steady state error

% print(TF)
% figure();
% pzmap(tf1(1));
[wn,z]=damp(sys);
figure();
pzmap(tf1(2));
[wn1,z1]=damp(sys);

end


function [ess,s,tf1,wn,z] =  req_9(kp,m1,m2,k1,k2,k3,f1,f2)
B1 = tf(k1,1);
B2 = tf(k2,1);
B3 = tf([f1,0],1);
B4 = tf(1,[m1,0,0]);
B5 = tf(k3,1);
B6 = tf([f2,0],1);
B7 = tf([m2,0,0],1);
B8 = tf(k2,1);
B9 = tf(1,k2);
B10 =tf(k2,1);
B11=tf(kp,1);

BlockMat = append(B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11);

connect_map =[1, 4, 0, 0,0,0; ... 
 2, 4, 0, 0,0,0; ...
 3, 4, 0, 0,0,0; ...
 4, -1, -2, -3,10,11; ...
 5,9, 0, 0,0,0; ...
 6,9, 0, 0,0,0; ...
 7,9, 0, 0,0,0; ...
 8,4, 0, 0,0,0; ...
 9,-5, -6, -7,8,0; ...
 10,9, 0, 0,0,0; ...
 11,-9, 0, 0,0,0; ...

];
input_loc = 11; 
output_loc = [4,9]; 


sys=connect(BlockMat,connect_map,input_loc,output_loc);
figure();

% figure();
tf1=tf(sys);
opt=stepDataOptions('InputOffset',0,'StepAmplitude',4);
p=stepplot(tf1(2),opt);
setoptions(p,'RiseTimeLimits',[0,1]);
s=stepinfo(tf1(2));
SP=4; %input value, if you put 1 then is the same as step(sys)
[y,t]=step(SP*tf1(2)); %get the response of the system to a step with amplitude SP
ess=abs(SP-y(end)) %get the steady state error

% print(TF)
% figure();
% pzmap(tf1(1));
[wn,z]=damp(tf1(2));
figure();
pzmap(tf1(2));
[wn1,z1]=damp(sys);



end
function [ess,s,tf1,wn,z] =  req_10(ki,kp,m1,m2,k1,k2,k3,f1,f2)
B1 = tf(k1,1);
B2 = tf(k2,1);
B3 = tf([f1,0],1);
B4 = tf(1,[m1,0,0]);
B5 = tf(k3,1);
B6 = tf([f2,0],1);
B7 = tf([m2,0,0],1);
B8 = tf(k2,1);
B9 = tf(1,k2);
B10 =tf(k2,1);
B11=tf([kp,ki],[1,0]);

BlockMat = append(B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11);

connect_map =[1, 4, 0, 0,0,0; ... 
 2, 4, 0, 0,0,0; ...
 3, 4, 0, 0,0,0; ...
 4, -1, -2, -3,10,11; ...
 5,9, 0, 0,0,0; ...
 6,9, 0, 0,0,0; ...
 7,9, 0, 0,0,0; ...
 8,4, 0, 0,0,0; ...
 9,-5, -6, -7,8,0; ...
 10,9, 0, 0,0,0; ...
 11,-9, 0, 0,0,0; ...

];
input_loc = 11; 
output_loc = [4,9]; 


sys=connect(BlockMat,connect_map,input_loc,output_loc);
figure();

% figure();
opt=stepDataOptions('InputOffset',0,'StepAmplitude',4);
p=stepplot(sys,opt);
setoptions(p,'RiseTimeLimits',[0,1]);
s=stepinfo(sys);
SP=4; %input value, if you put 1 then is the same as step(sys)
[y,t]=step(SP*sys); %get the response of the system to a step with amplitude SP
ess=abs(SP-y(end)) %get the steady state error
tf1=tf(sys);
% print(TF)
figure();
pzmap(tf1(1));
[wn,z]=damp(sys);
figure();
pzmap(tf1(2));
[wn1,z1]=damp(sys);

end

