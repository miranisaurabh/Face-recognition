clear;
srcFiles = dir('C:\Users\miran\Documents\Linear Algebra Project\Images\*a.jpg');
data = zeros(31266,190);
for i=1:190
    fileName = strcat('C:\Users\miran\Documents\Linear Algebra Project\Images\',srcFiles(i).name);
    I = imread(fileName);
    data(:,i) = I(:);
end

mu = mean(data,2);
phi = data - mu;

%C = phi*phi';
C_small = phi'*phi;
[V,D] = eig(C_small);

U = phi*V;
S = svd(data);
figure;
plot(S);

%% Part (b)

phi_norm = normalize(phi,'norm');
err = Inf(1,190);
test_image = imread('100a.jpg');
% for i=1:190
%     reconstruct = ((data(:,1).*phi_norm(:,1:i))').*phi_norm(:,1:i);
%     reconstruct = sum(reconstruct,2);
%     reconstruct = uint8(reconstruct);
%     reconstruct_img = reshape(reconstruct,[193,162]);
%     err(i) = immse(reconstruct_img, test_image);
%     disp(i);
% end

% for i=1:190
%     x_dot_vi = sum((data(:,1).*phi_norm(:,1:i)));
%     x_k_comp = x_dot_vi.*phi_norm(:,1:i);
%     x_k = sum(x_k_comp,2);
%     reconstruct = uint8(x_k);
%     reconstruct_img = reshape(reconstruct,[193,162]); 
%     err(i) = immse(reconstruct_img, test_image);
% end
U_norm = normalize(U,'norm');
[V,~] = eigs(C_small,190);
V_i = phi*V;
V_i_norm = normalize(V_i,'norm');

for i=1:190
    
%    x_hat = mu + U_norm(:,1:i)*(U_norm(:,1:i)'*data(:,1));
    x_hat = mu + V_i_norm(:,1:i)*V_i_norm(:,1:i)'*data(:,1);
    reconstruct_img = reshape(x_hat,[193,162]);
    reconstruct_img = uint8(reconstruct_img);
    err(i) = immse(reconstruct_img, test_image);
    Euc = norm(x_hat-data(:,1));
    
end
disp(Euc);
figure;
plot(err);
figure;
imshow(reconstruct_img);