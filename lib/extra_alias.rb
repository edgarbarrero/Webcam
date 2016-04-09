module ExtraAlias

  # Reescribimos alias_method_chain de la gem multiarray para tener en cuenta activesupport
  def alias_method_chain(target, feature, *extra)
    if !block_given? && extra.present?
      vocalize = extra.first
      super(target, feature) do |aliased_target, punctuation|
        if target.to_s == "=="
          punctuation.clear
        end
        aliased_target.replace vocalize.to_s
      end
    else
      super
    end
  end

end
