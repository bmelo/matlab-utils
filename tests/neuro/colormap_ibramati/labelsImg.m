function labelsImg( mat, orderReverse )
if( ~exist('orderReverse','var') )
  orderReverse = false;
end
tam = size(mat,1);
textStrings = num2str(mat(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
if any(strcmp(textStrings,'NaN')) %Remove os textos 'NaN'
  textStrings( strcmp(textStrings,'NaN') ) = {''};
end
[x,y] = meshgrid( 1:tam );   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
if orderReverse
  textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the text color of the strings so they can be easily seen over the background color
else
  textColors = repmat(mat(:) < midValue,1,3);  %# Choose white or black for the text color of the strings so they can be easily seen over the background color
end
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

end