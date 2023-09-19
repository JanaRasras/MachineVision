%
%   Jana Rusrus [#300205310]
%   Assignment 4 - 

clear, clc, close all

tic

%% --------------- Question --------------- %% 

% Homogeneous Transformations                      
TransformMatrix =@(phi, x, y, z) [ ...
                    cosd(phi), 0,  sind(phi),  x; ...
                    0,         1,  0,          y; ... 
                   -sind(phi), 0,  cosd(phi),  z; ...
                    0,         0,  0,          1  
                 ];

Q = struct( 'p1c', TransformMatrix(-30, 0, 0, 1700), ...     
            'p2c', TransformMatrix(15, -1830, 0, 1460), ...  
            'p3c', TransformMatrix(60,  1366, 0, 1334) ...
           );

    
% Perspective Projection
ProjectionMatrix =@(L_focal) [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 1/L_focal 0];

% Constants
Lp = 2000;          % Plane width & height [mm]
Np = 2000;          % Number of pixels in a Plane
Lc = 12.7;          % Camera image width & height [mm]
Nc = 640;           % Number of pixels in camera image
Rs = 20;            % Sensor sample rate [1 sample / 20 mm]


%% --------------- Build the World --------------- %% 

F_len = 2.5; 

% Planar Surfaces w.r.t. Camera 1 (flatten)
world.xyzw = ProjectionMatrix(F_len) * [ 
                Q.p1c * Plane('4D', Lp, Np, 1), ...
                Q.p2c * Plane('4D', Lp, Np, 1), ...
                Q.p3c * Plane('4D', Lp, Np, 1) ...
             ];
world.rgb = [ Texture('P1', Plane('2D', Lp, Np, 1)), ...
              Texture('P2', Plane('2D', Lp, Np, 1)), ...
              Texture('P3', Plane('2D', Lp, Np, 1)) ...
           ];
world.points = world.xyzw(1:2,:) ./ [world.xyzw(4,:); world.xyzw(4,:)];


% Limit Points to Camera's View 
ViewFilter =@(xy, L) all( (xy > -L/2) & (xy < L/2) );   % expects [x;y]

camera.mask = ViewFilter(world.points, Lc);
camera.points = world.points(:, camera.mask );
camera.rgb = world.rgb(:, camera.mask);

camera.colorID = sum([1 * camera.rgb(1,:);
                      2 * camera.rgb(2,:); 
                      4 * camera.rgb(3,:)]);


% Quantize Points to 640 x 640 bins (pixels)
delta = Lc / Nc;

for k = 5:-1:1
    camera.color_loc = (camera.colorID == k);

    h = histogram2( camera.color_loc .* camera.points(1,:), ...
                    camera.color_loc .* camera.points(2,:), ...
                    linspace(-(Lc-delta)/2, (Lc-delta)/2, Nc), ...
                    linspace(-(Lc-delta)/2, (Lc-delta)/2, Nc) ...
                 );
    pixels.counts{k} = h.Values;

end

% Pixels (Color-coded) to Image (RGB)
pixels.counts = cat(3, ...
                zeros(Nc-1), ...      % represents black
                pixels.counts{:} ...  % represents 5 colors (R,G,B,Y,M)
            );

[~, pixels.colorID] = max(pixels.counts, [], 3);

scene = rot90(reshape( ...
                    de2bi(pixels.colorID(:)-1, 3), ...
                    Nc-1, Nc-1, 3 ...
                ));
    
figure(1), imshow(scene), box off
title( sprintf('Image view via the camera at focal length = %.1f mm', F_len) )


% clear pixels camera world

toc



%% --------------- Solution of HW2 --------------- %% 

modes = [1, 2, 3];

world.xyzw2 = [ 
                Q.p1c * Plane('4D', Lp, Np, 1), ...
                Q.p2c * Plane('4D', Lp, Np, 1), ...
                Q.p3c * Plane('4D', Lp, Np, 1) ...
             ];

sensor.xyzw =  [
            Q.p1c * Plane('4D', Lp, Lp/Rs, Rs-1), ...
            Q.p2c * Plane('4D', Lp, Lp/Rs, Rs-1), ...
            Q.p3c * Plane('4D', Lp, Lp/Rs, Rs-1)  ...
        ];
    

%% --------------- Appendix --------------- %% 

new.world.rgb = { Texture('P1', Plane('2D', Lp, Np, 1)), ...
                  Texture('P2', Plane('2D', Lp, Np, 1)), ...
                  Texture('P3', Plane('2D', Lp, Np, 1)) ...
                };
            
P1 = reshape(new.world.rgb{1}', 2000, 2000, 3);
P2 = reshape(new.world.rgb{2}', 2000, 2000, 3);
P3 = reshape(new.world.rgb{3}', 2000, 2000, 3);

indx = zeros(2000,2000);
indx(10:20:end, 10:20:end) = 1;
indx = (indx == 1);
mask(:,:,1) = indx;
mask(:,:,2) = indx;
mask(:,:,3) = indx;

Ps1 = reshape(P1(mask), 100, 100, 3);
Ps2 = reshape(P2(mask), 100, 100, 3);
Ps3 = reshape(P3(mask), 100, 100, 3);

Ps = cat(2, Ps2, Ps1, Ps3);
%figure(1); imshow(Ps)


%%
new.sensor.xyzw =  {
            Q.p1c * Plane('4D', Lp, Lp/Rs, Rs-1), ...
            Q.p2c * Plane('4D', Lp, Lp/Rs, Rs-1), ...
            Q.p3c * Plane('4D', Lp, Lp/Rs, Rs-1)  ...
        };

  
P1x = reshape(new.sensor.xyzw{1}', 100, 100, 4);
P2x = reshape(new.sensor.xyzw{2}', 100, 100, 4);
P3x = reshape(new.sensor.xyzw{3}', 100, 100, 4);

Psx = cat(2, P2x, P1x, P3x);
Psx = Psx(:,:,1:3);

new.Ps = reshape(Ps, [], 3);
new.Px = reshape(Psx, [], 3);

figure(2, 'Position', [0, 0, 9, 9])
subplot(211), pcshow(new.Px, new.Ps,'VerticalAxis','Y')
view(0,90)

subplot(212), pcshow(new.Px, new.Ps,'VerticalAxis','Z')
view(0,45)


%%
new.world.xyzw =  { 
                ProjectionMatrix(F_len) * Q.p1c * Plane('4D', Lp, Np, 1), ...
                ProjectionMatrix(F_len) * Q.p2c * Plane('4D', Lp, Np, 1), ...
                ProjectionMatrix(F_len) * Q.p3c * Plane('4D', Lp, Np, 1) ...
             };


%%
%{
indx2 = [indx(:); indx(:); indx(:)]';
indx2 = [indx2; indx2; indx2];

out = world.rgb(indx2);
out = reshape(out', 100,300,3);
imshow(out)

%}












% --------------------
temp = ProjectionMatrix(F_len) * [ 
         Q.p1c * Plane('4D', Lp, Np, 1), ...
         Q.p2c * Plane('4D', Lp, Np, 1), ...
         Q.p3c * Plane('4D', Lp, Np, 1) ];
world.xyz = temp(1:3,:) ./ repmat(temp(4,:),3,1);
world.depth = mat2gray(temp(3,:), [0, 2.1998e+03]);
world.depth = repmat(temp(3,:),3,1);

pcshow(world.xyz', world.depth' )
view(0,90)

