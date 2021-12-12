#****************************************************************************
#**
#**  File     :  /data/projectiles/AIFQuanticCluster01/AIFQuanticCluster01_script.lua
#**  Author(s):  Drew Staltman, Gordon Duclos
#**
#**  Summary  :  Quantic Cluster Projectile script
#**
#**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

AIFQuanticCluster01 = Class(import('/lua/aeonprojectiles.lua').AQuantumCluster) {

    OnImpact = function(self, TargetType, TargetEntity)

        local FxFragEffect = EffectTemplate.TFragmentationSensorShellFrag
        local ChildProjectileBP = '/projectiles/AIFQuanticCluster02/AIFQuanticCluster02_proj.bp'

        # Split effects
        for k, v in FxFragEffect do
            CreateEmitterAtEntity( self, self:GetArmy(), v )
        end

        local vx, vy, vz = self:GetVelocity()
        local velocity = 6

		# One initial projectile following same directional path as the original
        self:CreateChildProjectile(ChildProjectileBP):SetVelocity(vx, vy, vz):SetVelocity(velocity):PassDamageData(self.DamageData)

		# Create several other projectiles in a dispersal pattern
        local numProjectiles = 8
        local angle = (2*math.pi) / numProjectiles
        local angleInitial = RandomFloat( 0, angle )

        # Randomization of the spread
        local angleVariation = angle * 0.35 # Adjusts angle variance spread
        local spreadMul = 10 # Adjusts the width of the dispersal

        local xVec = 0
        local yVec = vy
        local zVec = 0

        # Launch projectiles at semi-random angles away from split location
        for i = 0, (numProjectiles -1) do
            xVec = vx + (math.sin(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
            zVec = vz + (math.cos(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
            local proj = self:CreateChildProjectile(ChildProjectileBP)
            proj:SetVelocity(xVec,yVec,zVec)
            proj:SetVelocity(velocity)
            proj:PassDamageData(self.DamageData)
        end
        local pos = self:GetPosition()
        self:Destroy()
    end,
}

TypeClass = AIFQuanticCluster01