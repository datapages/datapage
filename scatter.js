function getTypeVars(obj, type) {
  return Object.entries(obj)
    .filter(([key, value]) => 
      Array.isArray(value) && value.every(item => 
        item === null || typeof item === type
      )
    )
    .map(([key]) => key);
}

//cont_vars = getTypeVars(penguins, 'number')

export function scatter(data) {
  cont_vars = getTypeVars(penguins, 'number');
  viewof x_var = Inputs.select(cont_vars, {value: cont_vars[0], label: "X axis"});
  viewof y_var = Inputs.select(cont_vars, {value: cont_vars[1], label: "Y axis"});
  
  return data
}