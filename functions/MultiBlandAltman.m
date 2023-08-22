% Create multiple bland altmand plots and copy them to one single docked figure 
%
% REFERENCES
%   https://stackoverflow.com/questions/18477705/plotting-an-existing-matlab-plot-into-another-figure
%   

function MultiBlandAltman (DataMatrix,Headers)
[~,Ntrials] = size (DataMatrix);

Pairs = 1:2:Ntrials;                                   

Condition = 1;
% loop through every second data column 
for Trial = Pairs(1:end-1)                                                      
                                                                     
    data = DataMatrix (:,Trial:Trial+1);
    % remove Zeros and delete all the rows with NaN
    data(data==0) = NaN;
    data = rmmissing(data); 
    
    Figure.BAplot(Trial) = figure('WindowStyle', 'docked', ...
      'Name', sprintf('%s', Headers{Condition}), 'NumberTitle', 'off');     
    
    % create BA plots
    [baAH,fig] = plot_BlandAltman(data);
    
    % add plots to the main figure
    hc = get (fig,'children');
    copyobj(hc,Figure.BAplot(Trial))    

    % save individual plots and mat figures
    saveas(fig,Headers{Condition},'jpeg');
    savefig (fig,Headers{Condition});

    Condition = Condition+1;
    close(fig)
end

% save with warning off to avoid message suggesting "savefig". Savefig does
% not work because only saves one plot
warning off
save("BAplotsAll_NoOutliers.mat","Figure")