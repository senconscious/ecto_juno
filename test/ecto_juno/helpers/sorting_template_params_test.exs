defmodule EctoJuno.Helpers.SortingTemplateParamsTest do
  use ExUnit.Case

  alias EctoJuno.Helpers.SortingTemplateParams

  @moduletag :sorting_template_params

  describe "get_sort_by/1" do
    test "sort_by provided in string key map" do
      assert SortingTemplateParams.get_sort_by(%{"sort_by" => "field"}) ==
               "field"
    end

    test "sort_by provided in atom key map" do
      assert SortingTemplateParams.get_sort_by(%{sort_by: "field"}) ==
               "field"
    end

    test "no sort_by provided" do
      assert SortingTemplateParams.get_sort_by(%{"sort_direction" => "desc"}) == nil
    end
  end

  describe "patch_sort_by/2" do
    test "overrides provided sort_by" do
      assert SortingTemplateParams.patch_sort_by(
               %{"sort_by" => "raw_field", "sort_direction" => "mode"},
               "field"
             ) == %{sort_by: "field", sort_direction: "mode"}
    end

    test "inserts new sort_by" do
      assert SortingTemplateParams.patch_sort_by(%{"sort_direction" => "mode"}, "field") == %{
               sort_by: "field",
               sort_direction: "mode"
             }
    end
  end
end
