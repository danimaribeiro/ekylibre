Ekylibre::Application.routes.draw do
  resource :session, :only=>[:new, :create, :destroy] do
    member do
      match "renew", :via=>[:get, :post]
    end
  end
  resource :company, :only=>[] do
    collection do
      match "register", :via=>[:get, :post]
    end
  end
  scope '/:company' do
    resource :myself, :as=>"me", :only=>[] do
      member do
        match "statistics", :via=>:get
        match "change_password", :via=>[:get, :post]
      end
    end
    resource :settings, :only=>[:edit, :update] do
      member do
        match "about", :via=>:get
        match "backups", :via=>:get
        match "backup", :via=>:post
        match "restore", :via=>:post
        match "import", :via=>[:get, :post]
      end
    end
    resources :dashboards, :only=>[] do
      collection do
        match "welcome", :via=>:get
      end
    end
    # Permits to use dynamic dashboards
    match '/dashboards/:action', :controller=>"dashboards", :via=>:get, :as=>:dashboard
    match '/toggle/side' => "interfacers#toggle_side"
    match '/toggle/submenu/:id' => "interfacers#toggle_submenu"
    match '/toggle/tab/:id' => "interfacers#toggle_tab"
    match '/intf/:action', :controller=>:interfacers, :via=>:get

    resources :help, :only=>[:index, :show]

    resources :account_balances
    resources :accounts do
      collection do
        get :list
        get :list_journal_entry_lines
        get :list_reconciliation
        get :list_entities
        match "load", :via=>[:get, :post]
        match "mark", :via=>[:get, :post]
      end
      member do
        match "unmark", :via=>[:get, :post]
      end
    end
    resources :areas do
      collection do
        get :list
      end
    end
    resources :bank_statements do
      collection do
        get :list
        get :list_lines
      end
      member do
        match "point", :via=>[:get, :post]
      end
    end
    resources :cashes do
      collection do
        get :list
        get :list_deposits
        get :list_bank_statements
      end
    end
    resources :cash_transfers do
      collection do
        get :list
      end
    end
    resources :contacts
    resources :cultivations
    resources :currencies
    resources :custom_fields do
      collection do
        get :list
        get :list_choices
      end
      member do
        match "sort", :via=>:post
      end
    end
    resources :custom_field_choices do
      member do
        match "up", :via=>:post
        match "down", :via=>:post
      end
    end
    resources :custom_field_data
    resources :delays do
      collection do
        get :list
      end
    end
    resources :departments do
      collection do
        get :list
      end
    end
    resources :deposits do
      collection do
        get :list
        get :list_payments
        get :list_depositable_payments
        get :list_unvalidateds
        match "unvalidateds", :via=>:get
      end
    end
    resources :deposit_lines
    resources :districts do
      collection do
        get :list
      end
    end
    resources :document_templates do
      collection do
        get :list
        match "load", :via=>:post
      end
      member do
        match "print", :via=>:get
        match "duplicate", :via=>:post
      end
    end
    resources :documents do
      collection do
        match "print", :via=>:get
      end
    end
    resources :entities do
      collection do
        get :list
        get :list_observations
        get :list_subscriptions
        get :list_sales
        get :list_purchases
        get :list_outgoing_payments
        get :list_mandates
        get :list_incoming_payments
        get :list_events
        get :list_contacts
        get :list_cashes
        get :list_links
        match "import", :via=>[:get, :post]
        match "export", :via=>[:get, :post]
        match "merge", :via=>[:get, :post]
      end
    end
    resources :entity_categories do
      collection do
        get :list
        get :list_prices
      end
    end
    resources :entity_links, :except=>[:index, :show]
    resources :entity_link_natures do
      collection do
        get :list
      end
    end
    resources :entity_natures do
      collection do
        get :list
      end
    end
    resources :establishments do
      collection do
        get :list
      end
    end
    resources :events do
      collection do
        get :list
        match "change_minutes", :via=>:get
      end
    end
    resources :event_natures do
      collection do
        get :list
      end
    end
    resources :financial_years do
      collection do
        get :list
      end
      member do
        match "close", :via=>[:get, :post]
      end
    end
    resources :incoming_deliveries do
      collection do
        get :list
      end
      member do
        match "confirm", :via=>[:get, :post]
      end
      resources :lines, :controller=>"incoming_delivery_lines"
    end
    resources :incoming_delivery_modes do
      collection do
        get :list
      end
    end
    resources :incoming_payments do
      collection do
        get :list
        get :list_sales
      end
    end
    resources :incoming_payment_modes do
      collection do
        get :list
      end
      member do
        match "up", :via=>:post
        match "down", :via=>:post
        match "reflect", :via=>:post
      end
    end
    resources :incoming_payment_uses
    resources :inventories do
      collection do
        get :list
        get :list_lines_create
        get :list_lines_update
      end
      member do
        match "reflect", :via=>[:get, :post]
      end
      resources :lines, :controller=>"inventory_lines"
    end
    resources :journals do
      collection do
        match "draft", :via=>[:get, :post]
        match "bookkeep", :via=>[:get, :post]
        match "balance", :via=>:get
        match "general_ledger", :via=>:get
        get :list
        get :list_draft_lines
        get :list_mixed
        get :list_lines
        get :list_entries
        get :list_general_ledger
      end
      member do
        match "close", :via=>[:get, :post]
        match "reopen", :via=>[:get, :post]
      end
    end
    resources :journal_entries do
      collection do
        get :list_lines
      end
    end
    resources :journal_entry_lines, :only=>[:new, :create]
    resources :land_parcels do
      collection do
        get :list
        get :list_operations
      end
      member do
        match "divide", :via=>[:get, :post]
      end
    end
    resources :land_parcel_groups do
      collection do
        get :list
      end
    end
    resources :land_parcel_kinships
    resources :listing_node_items
    resources :listing_nodes
    resources :listings do
      collection do
        get :list
      end
      member do
        match "extract", :via=>:get
        match "duplicate", :via=>:post
        match "mail", :via=>[:get, :post]
      end
    end
    resources :mandates do
      collection do
        get :list
        match "configure", :via=>[:get, :post]
      end
    end
    resources :observations    
    resources :operations do
      collection do
        get :list
        get :list_lines
        get :list_uses
        match "unvalidateds", :via=>[:get, :post]
      end
    end
    resources :operation_lines, :only=>[:new, :create]
    resources :operation_natures do
      collection do
        get :list
      end
    end
    resources :operation_uses
    resources :outgoing_deliveries do
      collection do
        get :list
      end
      resources :lines, :controller=>"outgoing_delivery_lines"
    end
    resources :outgoing_delivery_modes do
      collection do
        get :list
      end
    end
    resources :outgoing_payments do
      collection do
        get :list
        get :list_purchases
      end
    end
    resources :outgoing_payment_modes do
      collection do
        get :list
      end
      member do
        match "up", :via=>:post
        match "down", :via=>:post
      end
    end
    resources :outgoing_payment_uses
    resources :preferences
    resources :prices do
      collection do
        get :list
        match "export", :via=>[:get, :post]
        match "import", :via=>[:get, :post]
        match "find", :via=>:get
      end
    end
    resources :products do
      collection do
        get :list
        get :list_prices
        get :list_stocks
        get :list_stock_moves
        get :list_components
      end
    end
    resources :product_categories do
      collection do
        get :list
        get :list_products
      end
    end
    resources :product_components, :except=>[:show, :index]
    resources :production_chains do
      collection do
        get :list
      end
      resources :conveyors, :controller=>"production_chain_conveyors"
      resources :work_centers, :controller=>"production_chain_work_centers"
      resources :work_center_uses, :controller=>"production_chain_work_centers_uses"
    end
    resources :professions do
      collection do
        get :list
      end
    end
    resources :purchase_lines, :except=>[:index, :show]
    resources :purchases do
      collection do
        get :list
        get :list_lines
        get :list_undelivered_lines
        get :list_deliveries
        get :list_payment_uses
      end
      member do
        match "correct", :via=>:post
        match "propose", :via=>:post
        match "invoice", :via=>:post
        match "confirm", :via=>:post
        match "abort", :via=>:post
        match "refuse", :via=>:post
      end
    end
    resources :roles do
      collection do
        get :list
      end
    end
    resources :sale_lines, :except=>[:index, :show] do
      collection do
        get :list
        match "detail", :via=>:get
      end
    end
    resources :sale_natures do
      collection do
        get :list
      end
    end
    resources :sales do
      collection do
        get :list
        get :list_lines
        get :list_undelivered_lines
        get :list_subscriptions
        get :list_payment_uses
        get :list_deliveries
        get :list_credits
        get :list_creditable_lines
        get :statistics
        get :contacts
      end
      member do
        match "cancel", :via=>[:get, :post]
        post :duplicate
        post :correct
        post :propose
        post :invoice
        post :confirm
        post :abort
        post :refuse
        post :propose_and_invoice
      end
    end
    resources :sequences do
      collection do
        get :list
        post :load
      end
    end
    resources :stock_moves
    resources :stock_transfers do
      collection do
        get :list
        get :list_confirm
        match "confirm_all", :via=>[:get, :post]
      end
      member do
        match "confirm", :via=>[:get, :post]
      end
    end
    resources :stocks do
      collection do
        get :list
      end
    end
    resources :subscription_natures do
      collection do
        get :list
      end
      member do
        post :increment
        post :decrement
      end
    end
    resources :subscriptions do
      collection do
        get :list
        get :coordinates
        get :message
      end
    end
    resources :tax_declarations
    resources :taxes do
      collection do
        get :list
      end
    end
    resources :tools do
      collection do
        get :list
        get :list_operations
      end
    end
    resources :trackings do
      collection do
        get :list_stocks
        get :list_sale_lines
        get :list_purchase_lines
        get :list_operation_lines
      end
    end
    resources :tracking_states
    resources :transports do
      collection do
        get :list
        get :list_deliveries
        match "deliveries", :via=>[:get, :post]
        match "delivery_delete", :via=>[:get, :post]
      end
    end
    resources :transfers
    resources :units do
      collection do
        get :list
        post :load
      end
    end
    resources :users do
      collection do
        get :list
      end
      member do
        post :lock
        post :unlock
      end
    end
    resources :warehouses do
      collection do
        get :list
        get :list_stocks
        get :list_stock_moves
      end
    end

    match "/", :controller=>"dashboards", :action=>"general", :as=>"company_root"
  end
  
  root :to => "dashboards#general"
end
