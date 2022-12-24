class ApplicationController < ActionController::Base
  # deviseのコントローラはgem本体にあるため、ストロングパラメータはapplication_controllerに設定

  before_action :configure_permitted_parameters, if: :devise_controller? # if: :devise_controller?によって、deviseコントローラのみでの制御になる

  protected

  # deviseが初期で作るカラムの他に追加した場合、パラメータに入れる処理
  def configure_permitted_parameters # configure_permitted_parameters deviseのストロングパラメータ設定の専用のメソッド
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
