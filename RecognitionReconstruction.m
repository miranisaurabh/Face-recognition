clear;

%% Part (a)
srcFiles = dir('C:\Users\miran\Documents\Linear Algebra Project\Images\*a.jpg');
data_neutral = zeros(31266,190);

% Import Data - 1a to 190a Neutral faces
for i=1:190
    fileName = strcat('C:\Users\miran\Documents\Linear Algebra Project\Images\',srcFiles(i).name);
    I = imread(fileName);
    data_neutral(:,i) = I(:);
end

%For neutral
mu_neutral = mean(data_neutral,2); % Find mean of the data along columns
phi_neutral = data_neutral - mu_neutral; % Find the phi matrix

[U_neutral,S_neutral,~] = svd(phi_neutral,'econ'); % Get the orthonormal basis
S_neutral = diag(S_neutral); % Convert the singular diagonal matrix to column matrix for plotting
total_sum = sumsqr(S_neutral);
for k=1:190
    
    k_sum = sumsqr(S_neutral(1:k));
    variance_retained = k_sum/total_sum;
    if variance_retained > 0.85
        best_k = k;
        break;
    end
end

%Plot the singular values
% figure;
% plot(S_neutral);
% title('Singular Values for Neutral Faces')
% ylabel('Singular Values')
% xlabel('Number of PCs')

%% Part (b),(c),(d)

% Set error to infinite
err_neutral = Inf(1,190);
err_smiling = Inf(1,190);
err_projection = Inf(1,190);

% Read the images that we'll reconstruct
test_image_neutral = imread('100a.jpg');

test_image_smiling = imread('100b.jpg');
data_smiling = test_image_smiling(:);
data_smiling = double(data_smiling);

test_image_projection = imread('191a.jpg');
data_projection = test_image_projection(:); % Convert to column vector
data_projection = double(data_projection);

reconstruct_img_neutral = uint8(zeros(193,162,190));
reconstruct_img_smiling = uint8(zeros(193,162,190));
reconstruct_img_projection = uint8(zeros(193,162,190));

for i=1:190
    
    
    % Part (b) - Reconstruct Neutral expression (Reconstructing 100a)
    % x" = Mu + W*U ; where W = Transpose(U)*(x - Mu)
    x_hat_neutral = mu_neutral + U_neutral(:,1:i)*(U_neutral(:,1:i)'*(data_neutral(:,1)-mu_neutral));
    reconstruct_img_neutral(:,:,i) = uint8(reshape(x_hat_neutral,[193,162])); % Convert to image matrix from column vector
    err_neutral(i) = immse(reconstruct_img_neutral(:,:,i), test_image_neutral); % Calculate MSE
    
    % Part (c) - Reconstruct Smiling expression (Reconstructing 100b)
    x_hat_smiling = mu_neutral + U_neutral(:,1:i)*(U_neutral(:,1:i)'*(data_smiling-mu_neutral));
    reconstruct_img_smiling(:,:,i) = uint8(reshape(x_hat_smiling,[193,162]));
    err_smiling(i) = immse(reconstruct_img_smiling(:,:,i), test_image_smiling);
    
    % Part (d) - Reconstruct Neutral expression (Reconstruction 191a)
    x_hat_projection = mu_neutral + U_neutral(:,1:i)*(U_neutral(:,1:i)'*(data_projection-mu_neutral));
    reconstruct_img_projection(:,:,i) = uint8(reshape(x_hat_projection,[193,162]));
    err_projection(i) = immse(reconstruct_img_projection(:,:,i), test_image_projection); 
    
end

% Plot the MSE
figure;
plot(err_neutral);
title('MSE of reconstruction - Part (b)')
ylabel('MSE')
xlabel('Number of PCs')
figure;
sgtitle('Reconstruct one of 190 individuals’ neutral expression')
for num=1:9
    subplot(4,3,num), imshow(reconstruct_img_neutral(:,:,20*num));
    title(['No. of PCs:',num2str(20*num)])
end
subplot(4,3,10), imshow(reconstruct_img_neutral(:,:,190));
title(['No. of PCs:',num2str(190)])
subplot(4,3,11), imshow(reconstruct_img_neutral(:,:,best_k));
title(['Chose no. of PCs:',num2str(best_k)])
subplot(4,3,12), imshow(test_image_neutral);
title('Original Image')

figure;
plot(err_smiling);
title('MSE of reconstruction - Part (c)')
ylabel('MSE')
xlabel('Number of PCs')
figure;
sgtitle('Reconstruct one of 190 individuals’ smiling expression')
for num=1:9
    subplot(4,3,num), imshow(reconstruct_img_smiling(:,:,20*num));
    title(['No. of PCs:',num2str(20*num)])
end
subplot(4,3,10), imshow(reconstruct_img_smiling(:,:,190));
title(['No. of PCs:',num2str(190)])
subplot(4,3,11), imshow(reconstruct_img_smiling(:,:,best_k));
title(['Chose no. of PCs:',num2str(best_k)])
subplot(4,3,12), imshow(test_image_smiling);
title('Original Image')


figure;
plot(err_projection);
title('MSE of reconstruction - Part (d)')
ylabel('MSE')
xlabel('Number of PCs')
figure;
sgtitle('Reconstruct one of the other 10 individuals’ neutral expression')
for num=1:9
    subplot(4,3,num), imshow(reconstruct_img_projection(:,:,20*num));
    title(['No. of PCs:',num2str(20*num)])
end
subplot(4,3,10), imshow(reconstruct_img_projection(:,:,190));
title(['No. of PCs:',num2str(190)])
subplot(4,3,11), imshow(reconstruct_img_projection(:,:,best_k));
title(['Chose no. of PCs:',num2str(best_k),''])
subplot(4,3,12), imshow(test_image_projection);
title('Original Image')

%% Part (e) - Non-human being image

% Using flower image as non-human image
test_nonhuman = imread('flower.jpeg');
% Crop it to 193x162
targetSize = [193 162];
r = centerCropWindow2d(size(test_nonhuman),targetSize);
J = imcrop(test_nonhuman,r);
% Convert to column vector
data_nonhuman = J(:);
% Conver to double from uint8
data_nonhuman = double(data_nonhuman);


% Reconstruct image

% x" = Mu + W*U ; where W = Transpose(U)*(x - Mu)
x_hat_nonhuman = mu_neutral + U_neutral*(U_neutral'*(data_nonhuman-mu_neutral));
reconstruct_img_nonhuman = reshape(x_hat_nonhuman,[193,162]);
reconstruct_img_nonhuman = uint8(reconstruct_img_nonhuman);
err_nonhuman = immse(reconstruct_img_nonhuman, J);

figure;
sgtitle('Non-human being image')
subplot(1,2,1), imshow(reconstruct_img_nonhuman);
title('Reconstructed Image')
subplot(1,2,2), imshow(J);
title('Original Image')
%% Part (f) - Rotation

err_rot = zeros(1,73);
figure;
sgtitle('Rotated Reconstructed Images')
test_image_neutral = imread('122a.jpg');
for angle=0:5:355

    rot_img = imrotate(test_image_neutral, angle, 'crop');
    data_rot = rot_img(:);
    data_rot = double(data_rot);
    
    x_hat_rot = mu_neutral + U_neutral*(U_neutral'*(data_rot-mu_neutral));
    reconstruct_img_rot = reshape(x_hat_rot,[193,162]);
    reconstruct_img_rot = uint8(reconstruct_img_rot);
    err_rot(angle/5+1) = immse(reconstruct_img_rot, rot_img);
    
    if angle<=175
        subplot(6,6,angle/5 + 1), imshow(reconstruct_img_rot);
        title(['Rotation:',num2str(angle),'°'])
    elseif angle==180
        figure;
        sgtitle('Rotated Reconstructed Images')
        subplot(6,6,1), imshow(reconstruct_img_rot);
        title(['Rotation:',num2str(angle),'°'])
    else
        subplot(6,6,angle/5 - 35), imshow(reconstruct_img_rot);
        title(['Rotation:',num2str(angle),'°'])
    end
    

end

figure;
plot(0:5:360,err_rot);
title('Rotation angle v/s MSE')
xlabel('Rotation angle (in degrees)')
ylabel('MSE')
