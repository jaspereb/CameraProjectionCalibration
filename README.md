# CameraProjectionCalibration
A short tutorial on calibrating and validating 3D projection using a 2D camera and the matlab computer vision toolbox.

This walkthrough can be used to find the 3D locations of objects in a 2D image provided they sit on a flat plane which is also used for camera calibration. It requires the matlab computer vision system toolbox. Several matlab files are provided to make it easier, but you will need to create your own dataset using a fixed 2D camera (such as a webcam) and a printed chessboard target.

## Background
The problem is to take a 2D image from a camera with a known calibration (intrinsics and extrinsics) and calculate the position of objects in 3D space relative to it. We use a pinhole model and assume a flat ground plane so there will be some errors introduced by platform movement (it's mounted on a robot). Sample images look like the following:

![Calibration Image](https://github.com/jaspereb/CameraProjectionCalibration/blob/master/calibration.png)

![Validation Image](https://github.com/jaspereb/CameraProjectionCalibration/blob/master/validation.png)

Because the cameras are mounted upside down the image is inverted, this can either be flipped in preprocessing, or left as is. I used the inverted images for calibration, this just means the inverted images should also be used when determining bounding box locations. Note that the frame distance is not very far, beyond about 4m the accuracy declines significantly, obviously the more downward looking the better as the angular errors will add up less.

## Calibration Process
This process is used to get the intrinsic parameters matrix, as well as the extrinsic translation and rotation matrices. 

1. Install everything required to grab the images, I used spinView from FLIR (point grey) with a grasshopper camera. I set it up to grab a frame every 2 seconds and left it logging while I moved the target around. You will also need the matlab vision toolbox. 
2. Set up the camera in a fixed position on flat ground. This will not work if the camera downward angle, zoom, lens, resolution or orientation are changed, all of these require recalibration. 
3. Print a calibration chessboard, just a paper sheet of A3 worked fine for me, it should not be more than a few mm thick because we are trying the measure the ground plane. Measure the square size.
4. While logging the camera move the target around, try to take up the entire field of view, about 60% of my images were used by the matlab toolbox, the rest were rejected. 
5. It is essential that you have **at least one image where the target axes (x,y) align with the camera axes**. We will call this the **'reference image'** an example is below.
6. If you want to collect validation images now, continue with the following steps, otherwise skip these
7. For validation we need a small object (such as a nut) which we will place in known locations over a grid
8. Lay down a tape measure and grab a large ruler (or mark out a grid in some other way)
9. Place the object at each grid location (if these can be seen then you don't need an object). I placed it every 20cm horizontally and 50cm vertically to give a 7x4 grid of locations, this extends out to 2.5m from the camera
10. Log a separate image of each location

![App and Reference Image](https://github.com/jaspereb/CameraProjectionCalibration/blob/master/app.png)

Shown above is the calibrator app and a 'reference image' example where the x/y axes align with the camera.

So you should now have one folder with a bunch of chessboard images for calibration and another folder with test images for validation. Each validation image should have one grid point marked in it (by the object). You should also record the positions of each grid point.

1. Go through the calibration images and delete any where the chessboard is not perfectly flat and un-obscured.
2. Open up the matlab 'camera calibrator' app and load your calibration images. Run through the calibration steps and export the camera parameters, you don't need the uncertainty estimate.
3. We now just need to generate the extrinsic parameters.Use the calcExtrinsics.m script for this which will save the 'intrinsics', 'rotation' and 'translation' matrices for that camera setup. You will need the cameraParams object in your workspace (from the app) and set the path to the reference image. You also need to set the checkerboard square size. 

## Validation Process
1. The geoRef.m function actually does all the calculations, you need to set the three paths in this for it to work.
2. Set the paths in validate.m and run this script. It will grab every image in the test folder and ask you to click the reference point in that image
3. At the end it will show a 3D plot of your target points. This should match your test grid of points.

**However**, the axes are with reference to the origin of the 'reference image' chessboard. To fix this work out the average x position error as the difference between the measured x and the validation grid points, repeat for y. Subtract the average values from every datapoint and the detected points should now line up with your validation grid.

![Results Grid](https://github.com/jaspereb/CameraProjectionCalibration/blob/master/grid.png)

Here are the results of my validation, the camera origin was adjusted to match the y position of only the first row. Red points are the ground truth.

As you can see, points further from the camera start to diverge from the true locations. This is using a wide angle downwards facing camera to try and minimise these effects, but accuracy will suffer beyond 3m.

Summary
This process worked better than expected and the matlab toolbox makes it easy to do. It is very dependent on accurate calibration but we saw 10cm accuracy at 2.5m range for a monocular camera about 120cm off the ground. Platform motion will have a large effect so downwards facing cameras are recommended for precise georegistration.
