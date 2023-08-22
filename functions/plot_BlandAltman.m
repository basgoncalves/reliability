% [baAH,fig] = plot_BlandAltman(data)

function [H_scatter,fig] = plot_BlandAltman(data)

data(data==0) = NaN;
data = rmmissing(data);
x = data(:,1);
y = data(:,2);

Sessiondiff = (y-x);

MeanDiff = mean(Sessiondiff);
SDDiff = std(Sessiondiff);
N = length(Sessiondiff);
t = tinv(0.975,N);

%  CI of LoA - https://journals.sagepub.com/doi/10.1177/0962280216665419?url_ver=Z39.88-2003&rfr_id=ori:rid:crossref.org&rfr_dat=cr_pub%20%200pubmed
uLOA = MeanDiff+(1.96*SDDiff);
uLOACIu = uLOA + t*sqrt(2.92)*(SDDiff/sqrt(N));
uLOACIl = uLOA - t*sqrt(2.92)*SDDiff/sqrt(N);

lLOA = MeanDiff-(1.96*SDDiff);
lLOACIu = lLOA + t*sqrt(2.92)*SDDiff/sqrt(N);
lLOACIl = lLOA - t*sqrt(2.92)*SDDiff/sqrt(N);


x=mean(data,2);
y=Sessiondiff;
p = polyfit(x,y,1);
x2 = min(x):max(x)/100:max(x);
y2 = polyval(p,x2);
[R,~] = corrcoef (x,y);

fig = figure;
set(fig,'units','centimeters','position',[15 10 20 10],'color','w');

H_scatter = scatter(x,y,'SizeData',20,'MarkerFaceColor',[.7 .7 .7],...
        'MarkerEdgeColor','k');
   
hold on

xlabel('(Trial 1 + Trial 2) /2')
ylabel('Trial 2 - Trial 1')
xlim([min(x)*0.8 max(x)*1.1])
ylim([lLOACIl-10 uLOACIu+10])

%% plot mean baias
Limits =[MeanDiff uLOA lLOA uLOACIu uLOACIl lLOACIl lLOACIu];
Labels = {'Bias' 'uLoA' 'lLOA' 'CI' 'CI' 'CI' 'CI'};
LineType = {'--' '--' '--' ':' ':' ':' ':'};
FS = 13;
for i = 1:7
    plot([0 max(mean(data,2))],[Limits(i) Limits(i)],LineType{i},'color','k');
    BiasText = text(max(x)*1.05,Limits(i),sprintf('%s = %.0f',Labels{i},Limits(i)));
    BiasText.FontSize = FS;
    BiasText.FontName = 'Times New Roman';
end

%% plot zero level
plot([0 max(mean(data,2))],[0 0],'-','color','k');
set(gca,'FontSize', FS, 'Position', [0.18 0.22 0.7 0.65])

%% make figure nice
set(gcf,'Color',[1 1 1]);
set(gca,'box', 'off')
ax = gca;
ax.FontSize = 12; % change font size           

% make lines black and thickness = 2
N =  length(ax.Children);
LineThickness = 2;
for ii = 1:N
    if contains(class(ax.Children(ii)),'matlab.graphics.chart.primitive.Bar')
        ax.Children(ii).EdgeColor = 'k';
    elseif contains(class(ax.Children(ii)),'matlab.graphics.chart.primitive.Line')
        ax.Children(ii).LineWidth = LineThickness;
    end
end
grid off








