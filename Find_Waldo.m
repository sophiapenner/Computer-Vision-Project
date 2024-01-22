% Read images
Image1 = imread('WhereIsWaldo-1.jpg');
Image2 = imread('WhereIsWaldo-2.jpg');
Image3 = imread('WhereIsWaldo-3.jpg');

Waldo1 = imread('waldo1.jpg');
Waldo2 = imread('waldo2.jpg');
Waldo6 = imread('waldo6.jpg');

% Call function for each image
findWaldo(Image1, Waldo1);
findWaldo(Image2, Waldo6);
findWaldo(Image3, Waldo2);

% Define function. Input parameters are the scene and Waldo. 
function findWaldo(scene, target)

    % Convert images to grayscale
    scene = rgb2gray(scene);
    target = rgb2gray(target);
    
    % Find feature points
    scenePoints = detectSURFFeatures(scene);
    targetPoints = detectSURFFeatures(target);
    
    % Extract feature descriptors
    [targetFeatures, targetPoints] = extractFeatures(target, targetPoints);
    [sceneFeatures, scenePoints] = extractFeatures(scene, scenePoints);
    
    % Match features
    targetPairs = matchFeatures(targetFeatures, sceneFeatures);
    matchedTargetPoints = targetPoints(targetPairs(:, 1), :);
    matchedScenePoints = scenePoints(targetPairs(:, 2), :);
    
    % Localize target and remove outliers
    [tform, inlierTargetPoints, inlierScenePoints] = estimateGeometricTransform(matchedTargetPoints, matchedScenePoints,'affine');

    % Define bounding polygon
    targetPolygon = [1,1;size(target,2),1;size(target,2),size(target,1);1,size(target,1);1,1];
    newTargetPolygon = transformPointsForward(tform, targetPolygon);
    
    % Display output
    figure;
    imshow(scene);
    hold on;
    line(newTargetPolygon(:, 1), newTargetPolygon(:, 2), 'Color', 'y', 'LineWidth', 3);
    title('Found Waldo');
    
end