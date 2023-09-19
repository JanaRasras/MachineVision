%
%   **ELG 5163**: Assignment 1 - Camera Simulator
%   Jana Rusrus [#*************]
%
%   Elapsed time is 23.994330 seconds.
%

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

Q = struct( 'p1c1', TransformMatrix(-30, 0, 0, 1700), ...     % Part I
            'p2c1', TransformMatrix(15, -1830, 0, 1460), ...  %
            'p3c1', TransformMatrix(60,  1366, 0, 1334), ...  %
            'c2c1', TransformMatrix(-30, 1400, 0, -500), ...  % Part II
            'c3c1', TransformMatrix(45, -2000, 0, 0) ...      %
        );

    
% Perspective Projection
ProjectionMatrix =@(L_focal) [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 1/L_focal 0];

% Constants
Lp = 2000;          % Plane width & height [mm]
Np = 2000;          % Number of pixels in a Plane
Lc = 12.7;          % Camera image width & height [mm]
Nc = 640;           % Number of pixels in camera image


%% --------------- Solution --------------- %% 

F_len = [5, 2.5, 10, 5, 5]; 
cam = [1 1 1 2 3];

for i = 1:length(F_len)
    figure(i)

    switch i
      case {1,2,3}
        % Planar Surfaces w.r.t. Camera 1 (flatten)
        world.xyzw = ProjectionMatrix(F_len(i)) * [ 
                        Q.p1c1 * Plane('4D', Lp, Np, 1), ...
                        Q.p2c1 * Plane('4D', Lp, Np, 1), ...
                        Q.p3c1 * Plane('4D', Lp, Np, 1) ...
                     ];
        world.rgb = [ Texture('P1', Plane('2D', Lp, Np, 1)), ...
                      Texture('P2', Plane('2D', Lp, Np, 1)), ...
                      Texture('P3', Plane('2D', Lp, Np, 1)) ...
                   ];
        world.points = world.xyzw(1:2,:) ./ world.xyzw(4,:);

      case 4
        % Planar Surfaces w.r.t. Camera 2 (flatten)
        world.xyzw = ProjectionMatrix(F_len(i)) * [ 
                        Q.c2c1 \ Q.p1c1 * Plane('4D', Lp, Np, 1), ...
                        Q.c2c1 \ Q.p2c1 * Plane('4D', Lp, Np, 1), ...
                        Q.c2c1 \ Q.p3c1 * Plane('4D', Lp, Np, 1) ...
                     ];
        world.rgb = [ Texture('P1', Plane('2D', Lp, Np, 1)), ...
                      Texture('P2', Plane('2D', Lp, Np, 1)), ...
                      Texture('P3', Plane('2D', Lp, Np, 1)) ...
                   ];
        world.points = world.xyzw(1:2,:) ./ world.xyzw(4,:);
            
      case 5
        % Planar Surfaces w.r.t. Camera 3 (flatten)
        world.xyzw = ProjectionMatrix(F_len(i)) * [ 
                        Q.c3c1 \ Q.p1c1 * Plane('4D', Lp, Np, 1), ...
                        Q.c3c1 \ Q.p2c1 * Plane('4D', Lp, Np, 1), ...
                        Q.c3c1 \ Q.p3c1 * Plane('4D', Lp, Np, 1) ...
                     ];
        world.rgb = [ Texture('P1', Plane('2D', Lp, Np, 1)), ...
                      Texture('P2', Plane('2D', Lp, Np, 1)), ...
                      Texture('P3', Plane('2D', Lp, Np, 1)) ...
                   ];
        world.points = world.xyzw(1:2,:) ./ world.xyzw(4,:);     
    end

    % Limit Points to Camera's View 
    ViewFilter =@(xy, L) all( (xy > -L/2) & (xy < L/2) );   % expects [x;y]

    camera.mask = ViewFilter(world.points, Lc);
    camera.points = world.points(:, camera.mask );
    camera.rgb = world.rgb(:, camera.mask);

    camera.colorID = sum([1;2;4] .* camera.rgb);


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

    scene{i} = rot90(reshape( ...
                        de2bi(pixels.colorID(:)-1, 3), ...
                        Nc-1, Nc-1, 3 ...
                    ));
    
    imshow(scene{i}), box off
    title(sprintf('Image view via camera %d at focal length = %.1f mm', ...
                    cam(i), F_len(i)))
    

    clear pixels camera world
end

toc

%% --------------- Appendix --------------- %% 

function out = Plane(mode, L, N, dt)

    [x, y] = meshgrid( linspace(-(L-dt)/2, (L-dt)/2, N) );

    switch mode
        case '2D'
            out = [x(:) y(:)]';
        case '4D'
            z = zeros(N);    w = ones(N);
            out = [x(:) y(:) z(:) w(:)]';
        otherwise
           error('Unknown mode in Plane()')
    end
end


function out = Texture(tag, planeXY)
    
    N = 2000;
    R = zeros(1, length(planeXY));    G = R;    B = R;
    
    switch tag
        case 'P1'
            mask = all(planeXY > -N/4 & planeXY < N/4);
            R(mask) = 1;     G(mask) = 1;       % Yellow
            R(~mask) = 1;    B(~mask) = 1;      % Magenta
            
        case 'P2'
            mask = planeXY(2,:) < 0;
            B(mask) = 1;            % Blue
            G(~mask) = 1;           % Green
        case 'P3'
            mask1 = planeXY(1,:) <= -N/6;
            B(mask1) = 1;
            mask2 = planeXY(1,:) >= N/6;
            R(mask2) = 1;
            G(~(mask1 | mask2)) = 1;
        otherwise
           error('Unknown tag in Texture()')
    end
    
    out = [R; G; B];
    
     % c = reshape(out', 2000, 2000, 3);
     % p = reshape(planeXY', 2000, 2000, 2);
     % figure(10)
     % surf(p(:,:,1), p(:,:,2), 5*ones(2000), c, 'EdgeColor', 'none')
      
end
