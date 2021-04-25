defmodule MealsMonitor do
  alias MealsMonitor.Meals.Create, as: CreateMeal
  alias MealsMonitor.Meals.Delete, as: DeleteMeal
  alias MealsMonitor.Meals.Get, as: GetMeal
  alias MealsMonitor.Meals.Update, as: UpdateMeal

  defdelegate create_meal(params), to: CreateMeal, as: :call
  defdelegate get_meal_by_id(id), to: GetMeal, as: :by_id
  defdelegate update_meal(params), to: UpdateMeal, as: :call
  defdelegate delete_meal(id), to: DeleteMeal, as: :call
end
