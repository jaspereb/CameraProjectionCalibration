function [location] = georefPoint(pixX,pixY)
%georefPoint This function takes an image point and transforms it to an xyz
%position in space relative to the camera.
%   The input is in the form pixel X, pixel Y and the output is [x,y,z] in
%   mm relative to the camera. The function reads 3 configuration files
%   with the camera calibration data, both intrinsic and extrinsic. 

    %Load precalibrated camera matrix from app
    load('your path to/intrinsics.mat');
    load('your path to/rotation.mat');
    load('your path to/translation.mat');  
    
    imagePoints = [pixX, pixY];

    % Get the world coordinates
    worldPoints = pointsToWorld(cameraParams, R, t, imagePoints);

    % Remember to add the 0 z-coordinate.
    worldPoints = [worldPoints 0];

    % Compute the distance to the camera.
    [~, cameraLocation] = extrinsicsToCameraPose(R, t);

    location = (worldPoints-cameraLocation);
end