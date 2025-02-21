function wrappedImage = daugman(InputImage, irisBoundary, pupilBoundary, interval, angularScale, radialScale)
    % Input parameters:
    %   InputImage - Original RGB eye image (3D array)
    %   irisBoundary - [xc, yc, r] of the iris
    %   pupilBoundary - [xc, yc, r] of the pupil
    %   interval - Angular sampling interval in degrees
    %   angularScale - Scaling factor for angular resolution (width adjustment)
    %   radialScale - Scaling factor for radial resolution (height adjustment)
    
    % Output parameters:
    %   wrappedImage - Wrapped iris image in polar coordinates (RGB)

    % Validate input parameters
    if length(irisBoundary) < 3 || length(pupilBoundary) < 3
        error('irisBoundary and pupilBoundary must have at least 3 elements [xc, yc, r].');
    end
    if irisBoundary(3) <= pupilBoundary(3)
        error('The iris radius must be larger than the pupil radius.');
    end
    if nargin < 5
        angularScale = 1; % Default angular scale
    end
    if nargin < 6
        radialScale = 1; % Default radial scale
    end

    % Getting the image dimensions
    [rows, cols, channels] = size(InputImage);

    % Calculating the number of angular and radial samples
    numAngles = ceil((360 / interval) * angularScale); % Angular samples (theta)
    numSamples = ceil((irisBoundary(3) - pupilBoundary(3)) * radialScale); % Radial samples (r)

    % Initializing the wrapped image
    wrappedImage = zeros(numSamples, numAngles, channels);

    % Loop through angles 
    for thetaIndex = 1:numAngles
        theta = (thetaIndex - 1) * (interval / angularScale) * (pi / 180); % Adjusted angular step in radians

        % Loop through radius from pupil to iris boundary
        for rIndex = 1:numSamples
            rNorm = rIndex / numSamples; % Normalize radius between 0 to 1
            radius = pupilBoundary(3) + rNorm * (irisBoundary(3) - pupilBoundary(3)); % Interpolated radius rate

            % Converting the polar by using Cartesian coordinates
            x = round(pupilBoundary(2) + radius * sin(theta)); % Map theta to rows in Y-axis
            y = round(pupilBoundary(1) + radius * cos(theta)); % Map radius to columns in X-axis

            % Validating the coordinates and sample the pixel
            if x > 0 && x <= rows && y > 0 && y <= cols
                for c = 1:channels
                    wrappedImage(rIndex, thetaIndex, c) = InputImage(x, y, c);
                end
            else
                % Assign zero if coordinates are invalid
                for c = 1:channels
                    wrappedImage(rIndex, thetaIndex, c) = 0;
                end
            end
        end
    end

    % If it is required normalize output for visualization 
    wrappedImage = uint8(wrappedImage); % Convert for RGB
    disp('Wrapped image generation complete.');
end