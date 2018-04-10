%this function calculates the camera extrinsics and saves them

%Generate the extrinsics matrix
%Read test image

imOrig = imread('/media/jasper/DataDrive/AprilCameraCalibration/Calibrate/calibration-04102018103535-6.png');

% imOrig = imread('the path to your "reference image" goes here, the axes must align.png');
figure; imshow(imOrig);
title('Input Image');

[im, newOrigin] = undistortImage(imOrig, cameraParams, 'OutputView', 'full');
figure; imshow(im);
title('Undistorted Image');

% Detect the checkerboard.
[imagePoints, boardSize] = detectCheckerboardPoints(im);

%  YOU NEED TO SET THIS VALUE
squareSize = 36.5; % in millimeters

worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Compute rotation and translation of the camera.
[R, t] = extrinsics(imagePoints, worldPoints, cameraParams);

save('intrinsics','cameraParams');
save('rotation','R');
save('translation','t');