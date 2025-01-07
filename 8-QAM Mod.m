% 1.satır-12.satır A şıkkı hakkındadır.
M = 8; % 8-QAM için M değeri
numSymbols = 200; % En az 200 sembol
k = log2(M); % Her semboldeki bit sayısı
numBits = numSymbols * k; % Gerekli bit sayısı

% Rastgele Bit Dizisi Oluşturma
dataIn = randi([0 1], numBits, 1); % Rastgele bit dizisi oluşturma

% Bit Dizisini Sembol Dizisine Dönüştürme
dataInMatrix = reshape(dataIn, length(dataIn)/k, k); % Bit dizisini k-bit sembol dizisine dönüştürme
dataSymbolsIn = bi2de(dataInMatrix); % Bitleri sembollere dönüştürme
% 12. satır sonu

% 16.satır-22.satır B şıkkı hakkındadır.
% 8-QAM Modülasyonu Uygulama ve Ortalama Gücü 1 Yapma
txSignal = qammod(dataSymbolsIn, M, 'gray', 'UnitAveragePower', true); % 8-QAM modülasyonu ve Gray kodlama kullanımı, Ortalama gücü 1 yapma

% Ortalama Gücü Hesaplama ve Yazdırma
signalPower = mean(abs(txSignal).^2); % Sinyalin ortalama gücünü hesaplama
fprintf('Average Power of Transmitted Signal: %f\n', signalPower); % Ortalama gücü yazdırma
% 22. satır sonu

% 24.satır-32.satır C şıkkı hakkındadır.
% Modüle Edilmiş Sinyali Görüntüleme (Gürültüsüz)
figure;
scatterplot(txSignal);
title('8-QAM Modulated Signal (No Noise)');
xlabel('In-phase');
ylabel('Quadrature');
grid on;
% 32. satır sonu

% 34.satır-43.satır D şıkkı hakkındadır.
% AWGN Kanaldan Geçirme (3dB ve 5dB SNR ile)
SNR_3dB = 3; % 3 dB SNR değeri
SNR_5dB = 5; % 5 dB SNR değeri

% 3 dB SNR ile
rxSignal_3dB = awgn(txSignal, SNR_3dB, 'measured');

% 5 dB SNR ile
rxSignal_5dB = awgn(txSignal, SNR_5dB, 'measured');
% 43. satır sonu

% 46.satır-61.satır E şıkkı hakkındadır.
% Yıldız Diyagramlarını Görüntüleme (Gürültü Sonrası)
figure;
scatterplot(rxSignal_3dB); % 3 dB SNR ile sinyali görüntüleme
title('Received 8-QAM Signal with 3 dB SNR');
xlabel('In-phase');
ylabel('Quadrature');
grid on;

figure;
scatterplot(rxSignal_5dB); % 5 dB SNR ile sinyali görüntüleme
title('Received 8-QAM Signal with 5 dB SNR');
xlabel('In-phase');
ylabel('Quadrature');
grid on;
% 61. satır sonu

% 63.satır-73.satır F şıkkı hakkındadır.
% 8-QAM Demodülasyonu Uygulama
dataSymbolsOut_3dB = qamdemod(rxSignal_3dB, M, 'gray'); % 8-QAM demodülasyonu ve Gray kodlama kullanımı (3 dB SNR)
dataSymbolsOut_5dB = qamdemod(rxSignal_5dB, M, 'gray'); % 8-QAM demodülasyonu ve Gray kodlama kullanımı (5 dB SNR)

% Sembol Dizisini Bit Dizisine Dönüştürme
dataOutMatrix_3dB = de2bi(dataSymbolsOut_3dB, k); % Sembolleri bitlere dönüştürme (3 dB SNR)
dataOutMatrix_5dB = de2bi(dataSymbolsOut_5dB, k); % Sembolleri bitlere dönüştürme (5 dB SNR)
dataOut_3dB = dataOutMatrix_3dB(:); % Bit dizisini yeniden oluşturma (3 dB SNR)
dataOut_5dB = dataOutMatrix_5dB(:); % Bit dizisini yeniden oluşturma (5 dB SNR)
% 73. satır sonu

% 75.satır ve sonrası G şıkkı hakkındadır.
% Bit Hata Oranını Hesaplama
[numErrors_3dB, ber_3dB] = biterr(dataIn, dataOut_3dB); % Bit hata oranı hesaplama (3 dB SNR)
[numErrors_5dB, ber_5dB] = biterr(dataIn, dataOut_5dB); % Bit hata oranı hesaplama (5 dB SNR)
fprintf('Bit Error Rate for 3 dB SNR = %f\n', ber_3dB);
fprintf('Bit Error Rate for 5 dB SNR = %f\n', ber_5dB);

% SNR ve BER değerlerini tanımlayın
SNR_values = [3 5];
BER = [ber_3dB, ber_5dB];

% BER vs SNR grafiğini çizme
figure;
stem(SNR_values, BER, '-o');
title('BER vs. SNR for 8-QAM');
xlabel('SNR (dB)');
ylabel('Bit Error Rate');
grid on;

% Sonuçları yazdırma
for i = 1:length(SNR_values)
    fprintf('SNR: %d dB, BER: %e\n', SNR_values(i), BER(i));
end
