width = 0.5;
length = 15;
cells = randi([0 1], length,length,length);
cells(6,6,1) = 1;
cells(6,7,1) = 1;
cells(6,5,1) = 1;
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

for i = 1:size(cells,1)
    for j = 1:size(cells,2)
        for k = 1:size(cells,3)
            [x,y,z] = setxyz(i,j,k, 0.5 - (k*0.01));
            hold on;
            cell_voxels(i,j,k) = surf(x,y,z, 'FaceColor', color(k,:));
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
                    % 26 checked cell neighbours
                    % Fewer than min_nghb neighbours -> cell dies
                    % Min_nghb-max_nghb living neighbours -> cell lives
                    % More than max_nghb living neighbours -> cell dies
                    % Max_nghb living neighbours -> cell becomes a live cell
                    min_nghb = 6;
                    max_nghb = 12;
                    if (neighbours < min_nghb)
                        cells(i,j,k) = 0; % Cell dies
                    elseif (neighbours >= min_nghb && neighbours <= max_nghb && cells(i,j,k) == 1)
                        cells(i,j,k) = 1; % Cell lives
                    elseif (neighbours == max_nghb && cells(i,j,k) == 0)
                        cells(i,j,k) = 1; % Cell becomes a live cell
                    else
                        cells(i,j,k) = 0; % Cell dies
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


function [x,y,z] = setxyz(posx,posy,posz,width)
x = [ posx+width  posx+width  posx+width  posx+width  posx+width; posx+width  posx+width posx-width posx-width  posx+width;posx+width  posx+width posx-width posx-width posx+width;posx+width  posx+width  posx+width posx+width posx+width];
y = [ posy+width posy-width posy-width  posy+width  posy+width; posy+width posy-width posy-width  posy+width  posy+width;posy+width posy-width posy-width  posy+width posy+width;posy+width posy-width posy-width posy+width posy+width];
z = [posz-width posz-width posz-width posz-width posz-width;posz-width posz-width posz-width posz-width posz-width;posz+width  posz+width  posz+width  posz+width posz+width;posz+width  posz+width  posz+width posz+width posz+width];    
end