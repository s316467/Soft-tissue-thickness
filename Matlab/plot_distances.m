

function plot_distances(men_u30,men_30_50, men_o50, women_u30, women_30_50,women_o50, landmark_names)

    mean_men_u30 = mean(men_u30, 2);
    mean_men_30_50 = mean(men_30_50, 2);
    mean_men_o50 = mean(men_o50,2);
    mean_women_u30 = mean(women_u30, 2);
    mean_women_30_50 = mean(women_30_50, 2);
    mean_women_o50 = mean(women_o50,2);
    
    figure;
    title('Men distances');
    plot(1:10, mean_men_u30,'DisplayName', 'Under 30');
    hold on;
    plot(1:10,mean_men_30_50, 'DisplayName','30-50');
    plot(1:10,mean_men_o50, 'DisplayName','Over 50');
    xlabel('Landmark');
    ylabel('Distances');
    xticks(1:length(landmark_names));
    xticklabels(landmark_names);
    legend('show');

    figure;
    title('Women distances');
    plot(1:10, mean_women_u30,'DisplayName', 'Under 30');
    hold on;
    plot(1:10,mean_women_30_50, 'DisplayName','30-50');
    plot(1:10,mean_women_o50, 'DisplayName','Over 50');
    xlabel('Landmark');
    ylabel('Distances');
    xticks(1:length(landmark_names));
    xticklabels(landmark_names);
    legend('show');







end