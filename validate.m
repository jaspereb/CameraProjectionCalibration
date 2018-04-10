%load parameters from calibration app
load('your path to /intrinsics.mat');

%Load list of test images
imagefiles = dir('path to your test images folder/*.png');      

fprintf('Currently validating on %d images \n', length(imagefiles));

locations = [];

for i = 1:length(imagefiles)
    currentfilename = fullfile(imagefiles(i).folder, imagefiles(i).name);
    imOrig = imread(currentfilename);
    [im, newOrigin] = undistortImage(imOrig, cameraParams);
    
    figure(1); imshow(im);
    title('Undistorted Image, Click on the reference point');
    
    [x,y] = ginput(1);
    x = x + newOrigin(1);
    y = y + newOrigin(2);
    
    figure(1);
    hold on
    scatter(x,y, 'xk');
    
    location = georefPoint(x,y);
    fprintf('X coordinate: %.3f and Y coordinate: %.3f \n', location(1), location(2));
    locations = [locations;location];

end

figure(2);
scatter3(locations(:,1),locations(:,2),locations(:,3));

for n = 1:size(locations,1)
    fprintf('%f3.3       ',locations(n,:))
    fprintf('\n');
end

