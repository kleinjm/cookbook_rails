# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /graphql" do
  it "executes the given query or mutation" do
    stub_schema_execute

    variables = { "myVariables" => "test" }
    query = "someLongQuery(input: { id: ID } { recipes { id name } })"
    operation_name = "signIn"

    post graphql_path(
      format: :json,
      variables: variables.to_json,
      query: query,
      operationName: operation_name
    )

    expect(CookbookRailsSchema).to have_received(:execute).with(
      query,
      variables: variables,
      context: { current_user: nil },
      operation_name: operation_name
    )
    expect(json_body).to eq("success" => true)
  end

  it "sets the current_user context" do
    stub_schema_execute
    user = sign_in_user

    post graphql_path(format: :json)

    expect(CookbookRailsSchema).to have_received(:execute).with(
      nil,
      variables: {},
      context: { current_user: user },
      operation_name: nil
    )
    expect(json_body).to eq("success" => true)
  end

  it "handles empty string variable hash type" do
    stub_schema_execute

    variables = "".to_json
    post graphql_path(format: :json, variables: variables)

    expect_schema_called_with({})
  end

  it "handles ActionController::Parameters variable hash type" do
    stub_schema_execute

    variables = { "ActionController" => "Parameters" }
    post graphql_path(format: :json, variables: variables)

    expect_schema_called_with(variables)
  end

  it "handles nil variable hash type" do
    stub_schema_execute

    post graphql_path(format: :json, variables: nil)

    expect_schema_called_with({})
  end

  it "raises error on unexpected params" do
    stub_schema_execute
    allow_any_instance_of(GraphqlController).
      to receive(:params).and_return(variables: :a_symbol)

    expect { post graphql_path(format: :json) }.
      to raise_error(ArgumentError, "Unexpected parameter: a_symbol")
  end

  it "raises all errors" do
    allow(CookbookRailsSchema).to receive(:execute).
      and_raise(GraphQL::ExecutionError.new("Error!"))

    expect { post graphql_path(format: :json) }.
      to raise_error(GraphQL::ExecutionError, "Error!")
  end

  it "handles errors in development" do
    suppress_output do
      allow(Rails.env).to receive(:development?).and_return(true)

      allow(CookbookRailsSchema).to receive(:execute).
        and_raise(GraphQL::ExecutionError.new("Error!"))

      post graphql_path(format: :json)

      expect(json_body.dig("error", "message")).to eq("Error!")
      expect(json_body.dig("error", "backtrace")).to_not be_blank
      expect(response).to have_http_status(:internal_server_error)
    end
  end

  def expect_schema_called_with(variables)
    expect(CookbookRailsSchema).to have_received(:execute).with(
      nil,
      variables: variables,
      context: { current_user: nil },
      operation_name: nil
    )
    expect(json_body).to eq("success" => true)
  end

  def stub_schema_execute
    allow(CookbookRailsSchema).to receive(:execute).and_return(success: true)
  end

  def suppress_output
    original_stdout = $stdout.clone
    original_stderr = $stderr.clone
    $stderr.reopen File.new("/dev/null", "w")
    $stdout.reopen File.new("/dev/null", "w")
    yield
  ensure
    $stdout.reopen original_stdout
    $stderr.reopen original_stderr
  end
end
