%% Seyun Kim ECE310 DSP Project 2
clc;
clear;
%%
load projIA;
% Run original sound
sound(speech, fs);
%% Part A)
ts = 1/fs;

[h, t] = impz(b, a, 100, fs);
[hf, wf] = freqz(b, a, 100);
[g, wgd] = grpdelay(b,a,100);
%%
figure();
subplot(3,1,1);
stem(t, h);
title("Impulse response of N=1 All-pass filter");
xlabel("n");
ylabel("amplitude");
subplot(3,1,2);
plot(wf, abs(hf));
ylim([0 2]);
ylabel("magnitude");
xlabel("frequency");
title("Frequency response of N=1 All-pass filter");
subplot(3,1,3);
plot(wgd, g);
xlabel("frequency");
ylabel("delay");
title("Group delay of N=1 All-pass filter");

%% Part b)
z = roots(a);
p = roots(b);
figure(2);
zplane(z,p);
title("Pole zero plot of N=1 All-pass filter");
%% Part c)
%sound(speech)
sound(filter(b,a,speech),fs)
% No audible distortion after filtering speech file to all pass filter.
%% Part d)
B = b;
A = a;
for i=1:50
    B = conv(B,b);
    A = conv(A,a);
end

[h, t] = impz(B,A,5000);
[hf, wf] = freqz(B,A,5000);
[g, wgd] = grpdelay(B,A,5000);
figure(3);
subplot(3,1,1);
stem(t, h);
title("Impulse response of N=50 nc");
ylabel("amplitude");
xlabel("n");
subplot(3,1,2);
plot(wf, abs(hf));
ylabel("amplitude");
xlabel("frequency");
title("Frequency response of N=50 AP filter nc");
subplot(3,1,3);
xlabel("frequency");
ylabel("amplitude");
plot(wgd, g);
title("Group delay of N=50 All-pass filter nc");
sound(filter(B,A,speech),fs);

z = roots(B);
p = roots(A);
figure(4);
zplane(z, p);
title("pole-zero plot of N=50 All-pass filter nc");
%% e)
% The audio is distorted because there's large group delay due to the high
% order. And also order of 50 causes numerical unstability which
% contributed in the distortion. 
%% DF1
temp_df1 = dfilt.df1(b,a);
df1 = dfilt.cascade(temp_df1, temp_df1);
for i=1:48
    df1 = dfilt.cascade(df1, temp_df1);
end
sound(filter(df1, speech),fs);

[h, t] = impz(df1,5000, fs);
[hf, wf] = freqz(df1, 5000);
[g, wg] = grpdelay(df1, 5000);

figure();
subplot(3,1,1);
stem(t, h);
xlabel("n");
ylabel("amplitude");
title("Impulse response of DF1");

subplot(3,1,2);
plot(wf, abs(hf));
ylim([0,2]);
title("Frequency response of DF1");
xlabel("frequency");
ylabel("amplitude");

subplot(3,1,3);
plot(wg, g);
title("Group delay of DF1");
xlabel("frequency");
ylabel("delay");

z = roots(df1.Stage(2,1).Numerator);
p = roots(df1.Stage(2,1).Denominator);

figure();
zplane(z, p);
title("Pole-zero plot of DF1");
%% DF1(not cascaded)
df1_nc = dfilt.df1(B,A);
sound(filter(df1_nc, speech),fs);

[h, t] = impz(df1_nc,5000, fs);
[hf, wf] = freqz(df1_nc, 5000);
[g, wg] = grpdelay(df1_nc, 5000);
figure();
subplot(3,1,1);
stem(t, h);
title("Impulse response of DF2(not cascaded)");
subplot(3,1,2);
plot(wf, abs(hf));
ylim([0,2]);
title("Frequency response of DF2(not cascaded)");
xlabel("frequency");
ylabel("amplitude");
subplot(3,1,3);
plot(wg, g);
title("Group delay of DF2(not cascaded)");
xlabel("frequency");
ylabel("delay");

z = roots(df1_nc.Numerator);
p = roots(df1_nc.Denominator);
figure();
zplane(z, p);
title("pole-zero plot of DF2 nc");
%% DF2(cascaded)
temp_df2 = dfilt.df2(b,a);
df2 = dfilt.cascade(temp_df2, temp_df2);
for j=1:48
    df2 = dfilt.cascade(df2, temp_df2);
end
sound(filter(df2, speech),fs);

[h, t] = impz(df2,5000, fs);
[hf, wf] = freqz(df2, 5000);
[g, wg] = grpdelay(df2, 5000);
figure();
subplot(3,1,1);
stem(t, h);
title("Impulse response of DF2");
xlabel("n");
ylabel("amplitude");

subplot(3,1,2);
plot(wf, abs(hf));
ylim([0,2]);
title("Frequency response of DF2");
xlabel("frequency");
ylabel("amplitude");

subplot(3,1,3);
plot(wg, g);
title("Group delay of DF2");
xlabel("frequency");
ylabel("delay");

z = roots(df2.Stage(2,1).Numerator);
p = roots(df2.Stage(2,1).Denominator);
figure();
zplane(z, p);
title("pole-zero plot of Allpass filter in Direct Form II");
%% DF2(not cascaded)
df2_nc = dfilt.df2(B,A);
sound(filter(df2_nc, speech),fs);

[h, t] = impz(df2_nc,5000, fs);
[hf, wf] = freqz(df2_nc, 5000);
[g, wg] = grpdelay(df2_nc, 5000);
figure();
subplot(3,1,1);
stem(t, h);
title("Impulse response of DF2(not cascaded)");
xlabel("n");
ylabel("amplitude");
subplot(3,1,2);
plot(wf, abs(hf));
title("Frequency response of DF2(not cascaded)");
xlabel("frequency");
ylabel("amplitude");
subplot(3,1,3);
plot(wg, g);
title("Group delay of DF2 not cascaded(not cascaded)");
xlabel("frequency");
ylabel("delay");

z = roots(df2_nc.Numerator);
p = roots(df2_nc.Denominator);
figure();
zplane(z, p);
title("pole-zero plot of DF2(not cascaded)");
%% DF2SOS
[s,g] = tf2sos(b,a);
temp_sos = dfilt.df2sos(s,g);
df2sos = dfilt.cascade(temp_sos, temp_sos);
for i=1:48
    df2sos = dfilt.cascade(df2sos, temp_sos);
end
[h, t] = impz(df2sos,5000, fs);
[hf, wf] = freqz(df2sos, 5000);
[gd, wg] = grpdelay(df2sos, 5000);

figure();
subplot(3,1,1);
stem(t, h);
title("Impulse response of DF2SOS");
xlabel("n");
ylabel("amplitude");

subplot(3,1,2);
plot(wf, abs(hf));
ylim([0,2]);
title("Frequency response of DF2SOS");
xlabel("frequency");
ylabel("amplitude");

subplot(3,1,3);
plot(wg, gd);
title("Group delay of DF2SOS");
xlabel("frequency");
ylabel("delay");

zplane(df2sos);
title("zp polot for DF2SOS");
sound(filter(df2sos, speech),fs);
%% DF2TSOS
[s,g] = tf2sos(b,a);
temp_ts = dfilt.df2tsos(s,g);
df2tsos = cascade(temp_ts, temp_ts);
for i=1:48
    df2tsos = cascade(df2tsos, temp_ts);
end

[h, t] = impz(df2tsos,5000, fs);
[hf, wf] = freqz(df2tsos, 5000);
[gd, wg] = grpdelay(df2tsos, 5000);

figure();
subplot(3,1,1);
stem(t, h);
title("Impulse response of DF2TSOS");
xlabel("n");
ylabel("amplitude");

subplot(3,1,2);
plot(wf, abs(hf));
title("Frequency response of DF2TSOS");
xlabel("frequency");
ylabel("amplitude");
ylim([0,2]);

subplot(3,1,3);
plot(wg, gd);
title("Group delay of DF2TSOS");
xlabel("frequency");
ylabel("delay");

figure();
[z,p,k] = zpk(df2tsos);
zplane(z,p);
title("zp polot for DF2TSOS");

sound(filter(df2tsos, speech),fs);
%% DF2TSOS
[z,p,k] = tf2zpk(b,a);
[s,g] = zp2sos(z,p,k);
temp_ts = dfilt.df2tsos(s,g);
DF2tsos = dfilt.cascade(repmat(temp_ts,50,1));
sound(filter(DF2tsos,speech),fs);
%%

% for i=1:48
%    df2tsos = dfilt.cascade(df2tsos, temp_ts);
% end

[h, t] = impz(df2tsos,5000, fs);
[hf, wf] = freqz(df2tsos, 5000);
[gd, wg] = grpdelay(df2tsos, 5000);
figure();
subplot(3,1,1);
stem(t, h);
title("Impulse response of DF2TSOS");
xlabel("n");
ylabel("amplitude");
subplot(3,1,2);
plot(wf, abs(hf));
title("Frequency response of DF2TSOS");
xlabel("frequency");
ylabel("amplitude");
ylim([0,2]);
subplot(3,1,3);
plot(wg, gd);
title("Group delay of DF2TSOS");
xlabel("frequency");
ylabel("delay");

figure();
[z,p,k] = zpk(df2tsos);
zplane(z,p);
title("zp polot for DF2TSOS");

sound(filter2(df2tsos, speech),fs);