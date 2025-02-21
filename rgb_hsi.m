function [H, S, I] = rgb_hsi(rgb)

    % Extract RGB channels from the image.
    R = double(rgb(:, :, 1)); % Converting R channel to double
    G = double(rgb(:, :, 2)); % Converting G channel to double
    B = double(rgb(:, :, 3)); % Converting B channel to double
    
    % Normalizing the channels
    r = R ./ (R + G + B + eps);
    g = G ./ (R + G + B + eps);
    b = B ./ (R + G + B + eps);
    
    % Obtaining the HSI channels
    numerator = 0.5 * ((r - g) + (r - b));
    denominator = sqrt((r - g).^2 + (r - b) .* (g - b));
    theta = acos(numerator ./ (denominator + eps));
    H = theta;
    H(b > g) = 2 * pi - H(b > g);
    H = H / (2 * pi); % Normalize to [0, 1]
    
    % Saturation channel
    S = 1 - (3 * min(min(r, g), b) ./ (r + g + b + eps));
    
    % Intensity channel
    I = (R + G + B) / (3 * 255); % Normalize by dividing by 255

    % Setting NaN values to zero
    H(isnan(H)) = 0;
    S(isnan(S)) = 0;
    I(isnan(I)) = 0;
end
