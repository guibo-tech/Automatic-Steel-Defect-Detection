amostras = ones(4,60); %incializa matriz de amostras
for n = 21:80
    img = strcat('F:\Engenharia Mecatrônica\10º  Semestre\TCC\PDI-RNA\PDI RNA\Ondulado\','ondulado (',int2str(n),').jpg');
    a = imread(img); %Imagem a ser processada

    %Pega uma regiao da imagem, onde possui informacoes de interesse
    for i=60: 150
     for j=100 : 700  
         for k=1: 3
         ii=i-59;
         jj=j-99;     
         b(ii,jj,k) = a(i,j,k);
         end
     end
    end

    c = rgb2gray(b); %Escala de cinza
    d = imadjust(c); %Ajuste de intensidade
    e = im2bw(d,0.4); %Binarizacao da imagem, limiar 0.4
    f = edge(e,'roberts'); %Extracao de bordas
    %method: sobel, roberts, prewitt, log, zerocross


    %Conta o número de bits '0' da matriz binária
    count_bits=0;
    for i=1: 90
        for j=1: 600
            if e(i,j)==0
                count_bits = count_bits + 1;
            end   
        end
    end

    %Conta o número de bordas em uma determinada linha longitudinal (no centro) da chapa
    count_edges = 0;
     for j=1 : 600     
         i=45;
         if f(i,j)==1
             count_edges = count_edges + 1;
         end   
     end

    hist_R = imhist(b(:,:,1));
    hist_G = imhist(b(:,:,2));
    hist_B = imhist(b(:,:,3));

     %Identifica quantos pixels possui da faixa 225 a 256 do canal R (intensidade alta de vermelho)
     count_px_R = 0;
     for i=225 : 256
         count_px_R = count_px_R + hist_R(i);
     end

     %Identifica quantos pixels possui da faixa 100 a 256 do canal B (intensidade alta de azul)
     count_px_B = 0;
     for i=125 : 256
         count_px_B = count_px_B + hist_B(i);
     end

     %Características extraídas
     count_bits;
     count_edges;
     count_px_R;
     count_px_B;

     A = [count_bits; count_edges; count_px_R; count_px_B];
     amostras(:,n-20) = A;
end

resultados = net(amostras);
corretos = 0;
errados = 0;
id_erro = 20;

for i = 1:60
    if (resultados(2,i) - resultados(1,i)) < 0
        corretos = corretos + 1;
    else
        errados = errados + 1;
        id_erro + i % Fala qual é a chapa com erro   
        id_erro = 20;
    end
        porcentagem = corretos*100/60;
end