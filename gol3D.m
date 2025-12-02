width = 0.5;
length = 31;
cells = zeros(length,length,length);
for i = -1:1
    for j = -1:1
        for k = -1:1
            cells(round(length/2) + i,round(length/2) + j,round(length/2) + k) = 1;
        end
    end
end
color = jet(length);
fig = figure("Name","3D Game of Life");
% Initialize the 3D plot
axis equal;
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
title('3D Game of Life Visualization');
grid on;
view(3)
cell_voxels = zeros(length,length,length);
% 0 - Moore neighborhood (6 cells checked)
% 1 - radial neighborhood
% 3 - von Neumann neighborhood
neighborhood = 2;
% Rules
survival = [1 4 5 6 7 8 9 10 11 12];
birth = [2 4 5 6];

for i = 1:size(cells,1)
    for j = 1:size(cells,2)
        for k = 1:size(cells,3)
            [x,y,z] = cube(i,j,k, 0.5 - (k*0.01));
            hold on;
            cell_voxels(i,j,k) = surface(x,y,z, 'FaceColor', color(k,:));
            hold off;
        end
    end
end

for t = 1:120
    for i = 1:size(cells,1)
        for j = 1:size(cells,2)
            for k = 1:size(cells,3)
                    % Update the cells based on the Game of Life rules (scaled up to 3D)
                    neighbours = 0;
                    if (i > 1 && i < length)
                        if (cells(i+1, j,k)==1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i-1, j,k)==1)
                            neighbours=neighbours+1;
                        end
                    end
                    if (i > 1 && i < length && j > 1 && j < length)
                        if (cells(i+1, j+1,k)==1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i-1, j+1,k)==1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i+1, j-1,k)==1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i-1, j-1,k)==1)
                            neighbours=neighbours+1;
                        end
                    end
                    if (j > 1 && j < length)
                        if (cells(i, j+1,k)==1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i, j-1,k)==1)
                            neighbours=neighbours+1;
                        end
                    end
                    if (j > 1 && j < length && k > 1 && k < length)
                        if (cells(i, j+1,k+1) ==1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i, j-1,k+1) ==1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i, j+1,k-1)==1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i, j-1,k-1)==1)
                            neighbours=neighbours+1;
                        end
                    end
                    if (k > 1 && k < length)
                        if (cells(i, j,k+1) ==1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i, j,k-1) == 1)
                            neighbours=neighbours+1;
                        end
                    end
                    if (k > 1 && k < length && i > 1 && i < length)
                        if (cells(i+1, j,k+1)==1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i+1, j,k-1) == 1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i-1, j,k+1) == 1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i-1, j,k-1) == 1)
                            neighbours=neighbours+1;
                        end
                    end
                    if (i > 1 && i < length && j > 1 && j < length && k > 1 && k < length)
                        if (cells(i+1, j+1,k+1)==1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i+1, j+1,k-1) == 1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i+1, j-1,k+1) == 1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i-1, j-1,k-1) == 1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i-1, j+1,k+1) == 1)
                            neighbours=neighbours+1;
                        end
                        if (cells(i-1, j+1,k-1) == 1)
                            neighbours=neighbours+1;
                        end
                    end
                    cells(i,j,k) = 0; % Cell dies
                    for s = 1:size(survival,1)
                        if (neighbours == survival(s))
                        cells(i,j,k) = cells(i,j,k); % Cell lives
                        end
                    end
                    for b = 1:size(birth,1)
                        if (neighbours == birth(b))
                        cells(i,j,k) = 1; % New cell is born
                        end
                    end
            end
        end
    end
    
    % Displaying cells
    for i = 1:size(cells,1)
        for j = 1:size(cells,2)
            for k = 1:size(cells,3)
                if cells(i,j,k) == 1
                    set(cell_voxels(i,j,k),'FaceAlpha', 1.0);
                    set(cell_voxels(i,j,k),'EdgeColor', 'flat');

                else
                    set(cell_voxels(i,j,k),'FaceAlpha', 0.0);
                    set(cell_voxels(i,j,k),'EdgeColor', 'none');
                end
            end
        end
    end
    drawnow
    %exportgraphics(fig, '3DGoL.gif', "Append", true);
    pause(0.5);
end


function [x,y,z] = cube(posx,posy,posz,width)
x = [ posx+width  posx+width  posx+width  posx+width  posx+width; posx+width  posx+width posx-width posx-width  posx+width;posx+width  posx+width posx-width posx-width posx+width;posx+width  posx+width  posx+width posx+width posx+width];
y = [ posy+width posy-width posy-width  posy+width  posy+width; posy+width posy-width posy-width  posy+width  posy+width;posy+width posy-width posy-width  posy+width posy+width;posy+width posy-width posy-width posy+width posy+width];
z = [posz-width posz-width posz-width posz-width posz-width;posz-width posz-width posz-width posz-width posz-width;posz+width  posz+width  posz+width  posz+width posz+width;posz+width  posz+width  posz+width posz+width posz+width];    
end