function Plotfig(tour,model)
tour=[tour tour(1)];
x=model.x;
y=model.y;
plot(x(tour),y(tour),'-hr',...
'LineWidth',2,...
'MarkerSize',12,...
'MarkerFaceColor',[0.1 0.9 0.2],...
'MarkerEdgeColor','y');
ax = gca; 
ax.FontSize = 12; 
ax.FontWeight='bold';
set(gca,'Color','k')
end