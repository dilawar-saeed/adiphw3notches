clc; close all; clear;

I = imread('clown.png');                % read image
I = im2double(I);    

if size(I, 3) == 3                      % if rgb convert to grayscale
    I = rgb2gray(I);
end

[H, W] = size(I);                       % get image size 
notch_filter = ones(H, W);              % initialize filter of image size

F_shifted = fftshift(fft2(I));          % finding frequency domain representation

spectrum = log(abs(F_shifted) + 1);     % normalized frequency spectrum

figure
imshow(spectrum, [])
title('Click notches and press Enter')

[x, y] = ginput;                        % mouse click input function

notch_positions = round([x y]);         % storing all clicks into an array
number_of_clicks = size(notch_positions, 1);

r = 7;                                  % radius of notch filter 

for i=1:number_of_clicks                % filtering at all click locations
    x = notch_positions(i, 1) - W/2;    % click co-ordinates offset
    y = notch_positions(i, 2) - H/2;
    
    [X, Y] = meshgrid(1:W, 1:H);        % initializes 2 arrays X and Y the size of the image

    % calculate squared distances from the notch positions
    neg_distance = (X - (W/2 + 1) - x).^2 + (Y - (H/2 + 1) - y).^2;
    pos_distance = (X - (W/2 + 1) + x).^2 + (Y - (H/2 + 1) + y).^2;
    
    notch_filter(neg_distance <= r^2) = 0;
    notch_filter(pos_distance <= r^2) = 0;
end

F_filtered = F_shifted.*notch_filter;   % applying filter to original shifted frequency domain representation

% convert to spatial domain
I_filtered = real(ifft2(ifftshift(F_filtered)));

figure
imshow(I_filtered)
title('Filtered Image')