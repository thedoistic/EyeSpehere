function visualizeCircles(img_edge, xc, yc, r_pupil, r_iris)

    % Visualizing the detected circles
    imshow(img_edge);
    hold on;
    viscircles([yc, xc], r_pupil, 'Color', 'r', 'LineWidth', 1.5); % Pupil circle
    viscircles([yc, xc], r_iris, 'Color', 'b', 'LineWidth', 1.5);  % Iris circle
    hold off;
    title('Pupil and Iris Detection');
end