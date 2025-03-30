# Stochastic Optimization-Aided Energy-Efficient Information Collection in Internet of Underwater Things Networks

This repository contains the MATLAB implementation of algorithms and simulation frameworks for energy-efficient information collection in Internet of Underwater Things (IoUT) networks using stochastic optimization. 

For more details, you can access the paper PDF [here](https://www.researchgate.net/publication/352210791_Stochastic_Optimization_Aided_Energy-Efficient_Information_Collection_in_Internet_of_Underwater_Things_Networks).

---

## Overview

Underwater sensor networks are challenged by limited energy resources and the harsh underwater environment. This project addresses these issues by:
- **Optimizing AUV Trajectories:** Using Particle Swarm Optimization (PSO) to plan energy-efficient paths.
- **Resource Allocation:** Employing a two-stage joint optimization algorithm based on Lyapunov optimization to balance energy consumption with the Age of Information (AoI) and network queue stability.
- **AoI Evaluation:** Assessing the freshness of collected data to ensure timely and efficient information collection.

---

## Repository Structure

```
.
├── Main.m                % Main script for AUV trajectory planning and energy optimization.
├── Main_AoI.m            % Script for simulating and computing the Age of Information (AoI).
├── AoI.m                 % Function to calculate AoI based on simulation results.
├── Ocean_Environment/    % Modules for modeling the underwater environment.
├── PSO/                  % Particle Swarm Optimization implementation for path planning.
├── Acoustic_communication/ % Functions modeling underwater acoustic communications.
├── Lyapunov_optimization/ % Implementation of the Lyapunov optimization based joint optimization.

```

---

## Requirements

- **MATLAB:** R20XXa (or later)  
- **Toolboxes:**  
  - Optimization Toolbox  
  - Signal Processing Toolbox (if applicable)  
- Make sure all subdirectories (e.g., `Ocean_Environment`, `PSO`, `Acoustic_communication`, `Lyapunov_optimization`) are added to your MATLAB path.

---

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/yourrepository.git
   ```
2. **Set Up in MATLAB:**
   - Open MATLAB and change your current directory to the repository folder.
   - Add all subdirectories to your MATLAB path:
     ```matlab
     addpath(genpath(pwd));
     ```

---

## Usage

- **Run the Main Simulation:**
  - Execute the main script to perform AUV trajectory planning and energy optimization:
    ```matlab
    run Main.m
    ```
- **AoI Simulation:**
  - Run the AoI simulation script to compute and analyze the Age of Information:
    ```matlab
    run Main_AoI.m
    ```
  
### Code Overview

- **Main.m:**  
  Initializes the simulation environment, sets up the underwater scenario, and calls the PSO-based trajectory planning along with the Lyapunov optimization for resource allocation.

- **Main_AoI.m:**  
  Focuses on simulating the information collection process and computes the AoI using the function defined in `AoI.m`.

- **AoI.m:**  
  Calculates the Age of Information by processing simulation outputs such as transmission rates and queue states.

### Customization

You can modify various parameters (e.g., AUV speed, transmission bitrates, environmental settings) in `Main.m` and `Main_AoI.m` to study their effects on energy efficiency and AoI. Additional plotting and data logging can also be incorporated as needed.


---

## Citation

If you use this code in your research, please cite the following paper:

```
@ARTICLE{9451536,
  author={Fang, Zhengru and Wang, Jingjing and Du, Jun and Hou, Xiangwang and Ren, Yong and Han, Zhu},
  journal={IEEE Internet of Things Journal}, 
  title={Stochastic Optimization-Aided Energy-Efficient Information Collection in Internet of Underwater Things Networks}, 
  year={2022},
  volume={9},
  number={3},
  pages={1775-1789},
  publisher={IEEE}
}

@ARTICLE{9312959,
  author={Fang, Zhengru and Wang, Jingjing and Jiang, Chunxiao and Zhang, Qinyu and Ren, Yong},
  journal={IEEE Internet of Things Journal}, 
  title={{AoI}-Inspired Collaborative Information Collection for {AUV}-Assisted Internet of Underwater Things}, 
  year={2021},
  volume={8},
  number={19},
  pages={14559-14571},
  publisher={IEEE}}
```
