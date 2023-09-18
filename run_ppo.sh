python /ManiSkill2-Learn/maniskill2_learn/apis/run_rl.py configs/mfrl/ppo/maniskill2_pn.py \
            --work-dir ./logging_dir --gpu-ids 0 \
            --cfg-options "env_cfg.env_name=PickCube-v0" "env_cfg.obs_mode=pointcloud" "env_cfg.n_points=1200" \
            "env_cfg.reward_mode=dense" "env_cfg.control_mode=pd_joint_delta_pos" \
            "eval_cfg.num=100" "eval_cfg.save_traj=False" "eval_cfg.save_video=True" 