clear; close all;  clc

N = 3;
array = [-2*ones(N), ones(N), 2*ones(N);
         -1*ones(N), zeros(N), ones(N);
         -0.5*ones(N), -1*ones(N), 0.5*ones(N)];
scene = array(:);

R = 9; r = 1;
Filter =@(x, R, r, i) (x >= (-R/2 + r);

Image = zeros(N);
for i = 1:N
    i;
end



%%
%%

camera.mask = ViewFilter(sensor.points, Lc);
camera.points = sensor.points .* [camera.mask; camera.mask] ;
%camera.points = world.points(:, camera.mask );
camera.pc = sensor.pc .* camera.mask;

k = 2000*2000;
scene = {camera.pc(1:k), camera.pc(k+1:2*k), camera.pc(2*k+1:end)};
scene = {reshape(scene{1}',2000,2000), reshape(scene{2}',2000,2000), reshape(scene{3}',2000,2000)};
scene = cat(2, scene{1}, scene{2}, scene{3});

imshow(scene, [min(scene(:)), max(scene(:))])
%%
% Distance to Image (RGB)

figure(1), imshow(scene, [min(scene(:)), max(scene(:))]), box off
title( sprintf('Image view via the camera at focal length = %.1f mm', F_len) )


% clear pixels camera world

