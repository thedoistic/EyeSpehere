function [center, pupilRadius, irisRadius] = chough(edgeMap, pupilRadiusRange, irisRadiusRange, stepSize)
    % Input parameters:
    % edgeMap            : Binary edge map of the image
    % pupilRadiusRange   : [minPupilRadius, maxPupilRadius]
    % irisRadiusRange    : [minIrisRadius, maxIrisRadius]
    % stepSize           : Increment for radius values
    
    % Output parameters:
    % center             : Center of the detected circles [xc, yc]
    % pupilRadius        : Detected pupil radius
    % irisRadius         : Detected iris radius
    
    % Initializing the input parameters
    [rows, cols] = size(edgeMap);
    accPupil = zeros(rows, cols, length(pupilRadiusRange(1):stepSize:pupilRadiusRange(2)));
    accIris = zeros(rows, cols, length(irisRadiusRange(1):stepSize:irisRadiusRange(2)));

    % Detecting the edges
    [yIdx, xIdx] = find(edgeMap);
    
    % Pupil Detection
    pupilRadii = pupilRadiusRange(1):stepSize:pupilRadiusRange(2);
    for i = 1:length(xIdx)
        xEdge = xIdx(i);
        yEdge = yIdx(i);

        for rIdx = 1:length(pupilRadii)
            radius = pupilRadii(rIdx);
            for theta = linspace(0, 2*pi, 100)
                xCenter = round(xEdge - radius * cos(theta));
                yCenter = round(yEdge - radius * sin(theta));

                if xCenter > 0 && xCenter <= cols && yCenter > 0 && yCenter <= rows
                    accPupil(yCenter, xCenter, rIdx) = accPupil(yCenter, xCenter, rIdx) + 1;
                end
            end
        end
    end

    % Iris Detection
    irisRadii = irisRadiusRange(1):stepSize:irisRadiusRange(2);
    for i = 1:length(xIdx)
        xEdge = xIdx(i);
        yEdge = yIdx(i);

        for rIdx = 1:length(irisRadii)
            radius = irisRadii(rIdx);
            for theta = linspace(0, 2*pi, 100)
                xCenter = round(xEdge - radius * cos(theta));
                yCenter = round(yEdge - radius * sin(theta));

                if xCenter > 0 && xCenter <= cols && yCenter > 0 && yCenter <= rows
                    accIris(yCenter, xCenter, rIdx) = accIris(yCenter, xCenter, rIdx) + 1;
                end
            end
        end
    end

    % Detecting to peaks in pupil accumulator
    [~, pupilIdx] = max(accPupil(:));
    [yPupil, xPupil, rPupil] = ind2sub(size(accPupil), pupilIdx);
    pupilRadius = pupilRadii(rPupil);

    % Detecting to peaks in iris accumulator
    [~, irisIdx] = max(accIris(:));
    [yIris, xIris, rIris] = ind2sub(size(accIris), irisIdx);
    irisRadius = irisRadii(rIris);

    % Checking if centers are within tolerance
    tolerance = 5; % Maximum allowed distance between centers like pixels
    if sqrt((xPupil - xIris)^2 + (yPupil - yIris)^2) > tolerance
        % Using the average center if they are close enough
        xCenter = round((xPupil + xIris) / 2);
        yCenter = round((yPupil + yIris) / 2);
    else
        % Taking the pupil center as reference
        xCenter = xPupil;
        yCenter = yPupil;
    end

    % Return results
    center = [xCenter, yCenter];
end