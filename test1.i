[Mesh]
    type = GeneratedMesh
    dim = 2
    nx = 100
    ny = 100  
    xmin = 0.0
    xmax = 200.0
    ymin = 0.0
    ymax = 200.0
[]

[Variables]
    [./c]
        family = LAGRANGE
        order = FIRST
    [../]
  
    [./mu]
        family = LAGRANGE
        order = FIRST
    [../]
[]

[Kernels]
    # C
    [./C1App]
        type = C1
        variable = c
    [../]
    [./C2]
        type = C2
        variable = c
        mu = mu
        M = 5
    [../]
    # mu
    [./M1]
        type = M1
        variable = mu
    [../]
    [./M2]
        type = M2
        variable = mu
        c = c
    [../]
    [./M3]
        type = M3
        variable = mu
        c = c
        lambda = 2
    [../]

[]

[ICs]
    [./det_ic]
      type = IC
      variable = c
      c0 = 0.5
      epsilon = 0.01
    [../]
  
    [./mu_ic]
      type = ConstantIC
      variable = mu
      value = 0.0
    [../]
  []
  

[BCs]
    [./c_flux]
      type = NeumannBC
      variable = c
      boundary = 'left right top bottom'
      value = 0.0
    [../]
    [./mu_flux]
      type = NeumannBC
      variable = mu
      boundary = 'left right top bottom'
      value = 0.0
    [../]
[]

[Adaptivity]
    initial_steps = 2
    initial_marker = refine_region
    max_h_level = 2
    marker = err_c
    interval = 10

    [./Markers]
        [./err_c]
            type = ErrorFractionMarker
            coarsen = 0.3
            refine = 0.75
            indicator = ind_c
        [../]
        [./refine_region]
                type = BoxMarker
                bottom_left = '0 0 0'  
                top_right = '200 200 0'   
                inside = refine         
                outside = do_nothing     
        [../]
    [../]
    [./Indicators]
        [./ind_c]
            type = GradientJumpIndicator
            variable = c
        [../]
    [../]
[]

[Executioner]
    type = Transient
    solve_type = PJFNK
    scheme = bdf2
    start_time = 0.0
    dtmin = 1e-4
    dtmax = 5.0
    end_time = 1000.0

  
    automatic_scaling = true
  
    nl_rel_tol = 1e-5
    nl_abs_tol = 1e-6
    nl_max_its = 60
    l_max_its = 200
  
    petsc_options_iname = '-ksp_type -pc_type'
    petsc_options_value = 'gmres ilu'
        
    [./TimeStepper]
      type = IterationAdaptiveDT
      optimal_iterations = 6
      iteration_window = 1
      linear_iteration_ratio = 100
      growth_factor = 1.1
      cutback_factor = 0.5
      dt = 1e-1
    [../]
[]
  



[Outputs]
    [./exodus]
      type = Exodus
      interval = 5     
      file_base = simulation     
      execute_on = 'initial timestep_end' 
    [../]
    [./checkpoint]
        type = Checkpoint
        time_step_interval = 20
        num_files = 2   
    [../]
[]