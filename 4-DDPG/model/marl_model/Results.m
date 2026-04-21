%% Algorithm 4 (Standard DDPG) 结果可视化脚本
clear; clc; close all;

% 设置绘图风格，确保线条平滑且字体易读
set(0, 'DefaultLineLineWidth', 2);
set(0, 'DefaultAxesFontSize', 12);
set(0, 'DefaultAxesFontWeight', 'bold');
set(0, 'DefaultFigureColor', [1 1 1]);

%% 1. 训练总奖励收敛 (Average Reward)
if exist('reward.mat', 'file')
    load('reward.mat'); % 变量名为 reward
    avg_reward = mean(reward, 1);
    
    figure('Name', 'Algo4 Average Reward');
    plot(avg_reward, 'Color', [0.4660 0.6740 0.1880]);
    grid on;
    title('DDPG Training Convergence: Average Total Reward');
    xlabel('Episode');
    ylabel('Cumulative Reward');
    saveas(gcf, 'Algo4_Result_1_Total_Reward.png');
end

%% 2. 各个用户的奖励分布 (Per-User Reward - 新增文件分析)
if exist('per_total_user_.mat', 'file')
    load('per_total_user_.mat'); % 经分析，变量名为 reward_per [n_platoon, n_episode]
    
    figure('Name', 'Per-User Reward Distribution');
    hold on;
    colors = lines(size(reward_per, 1));
    for i = 1:size(reward_per, 1)
        plot(smooth(reward_per(i, :), 20), 'Color', colors(i, :), 'DisplayName', ['Platoon ' num2str(i)]);
    end
    grid on;
    legend('Location', 'best', 'FontSize', 8);
    title('DDPG Per-Agent Learning Progress (Smoothed)');
    xlabel('Episode');
    ylabel('Individual Reward');
    saveas(gcf, 'Algo4_Result_2_Per_User_Reward.png');
end

%% 3. 系统信息新鲜度 (Average AoI)
if exist('AoI.mat', 'file')
    load('AoI.mat'); % 变量名为 AoI
    avg_aoi = mean(AoI, 1);
    
    figure('Name', 'Algo4 AoI Trend');
    plot(avg_aoi, 'Color', [0.6350 0.0780 0.1840]);
    grid on;
    title('DDPG System Performance: Average AoI');
    xlabel('Episode');
    ylabel('AoI (Time Steps)');
    saveas(gcf, 'Algo4_Result_3_AoI_Trend.png');
end

%% 4. 实时 AoI 锯齿波动 (最后一轮)
if exist('AoI_evolution.mat', 'file')
    load('AoI_evolution.mat');
    % 结构通常为 [n_platoon, 100, n_step]，取最后一次记录的平均值
    last_evol = squeeze(mean(AoI_evolution(:, end, :), 1));
    
    figure('Name', 'Algo4 AoI Realtime');
    plot(last_evol, 'b');
    grid on;
    title('Intra-Episode AoI Update Process (Last Episode)');
    xlabel('Step');
    ylabel('Instantaneous AoI');
    saveas(gcf, 'Algo4_Result_4_AoI_Evolution.png');
end

%% 5. V2V 任务完成速度 (Demand)
if exist('demand.mat', 'file')
    load('demand.mat');
    % 观察最后一轮 Demand 如何下降
    last_demand = squeeze(mean(demand(:, end, :), 1));
    
    figure('Name', 'Algo4 Demand Depletion');
    plot(last_demand, 'k', 'LineWidth', 2.5);
    grid on;
    title('V2V Message Transmission (Last Episode)');
    xlabel('Step');
    ylabel('Remaining Data (bits)');
    saveas(gcf, 'Algo4_Result_5_Demand_Step.png');
end

%% 6.V2I 与 V2V 资源竞争分析 (Throughput)
if exist('V2I.mat', 'file') && exist('V2V.mat', 'file')
    load('V2I.mat');
    load('V2V.mat');
    
    mean_v2i = squeeze(mean(mean(V2I, 1), 2));
    mean_v2v = squeeze(mean(mean(V2V, 1), 2));
    
    figure('Name', 'Algo4 Rate Comparison');
    
    % 左轴
    yyaxis left
    p1 = plot(mean_v2i, '-', 'LineWidth', 1.5); % 获取句柄 p1
    ylabel('V2I Rate (bps)');
    
    % 右轴
    yyaxis right
    p2 = plot(mean_v2v, ':', 'LineWidth', 1.5); % 获取句柄 p2
    ylabel('V2V Rate (bps)');
    
    grid on;
    title('Algorithm 4: Multi-Link Rate Balancing');
    xlabel('Step');
    
    % 设置图例：移到右上角外部，并手动对应线条
    legend([p1, p2], {'V2I Rate (Cellular)', 'V2V Rate (Platoon)'}, ...
           'Location', 'northeastoutside');
    
    % 调整图片大小以防图例被裁剪（可选）
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 0.8, 0.6]);
    
    saveas(gcf, 'Algo4_Result_6_Rate_Comparison.png');
end
fprintf('DDPG 算法结果可视化完成，所有图片已保存。\n');


