--!strict
--[[
	M14_Parental.spec.lua — Tests für M14 Parental/Privacy (COPPA/DSGVO)
]]

return function()
	-- M14 is server-side (lives in Services/)
	-- We test it via Server-side require
	local M14 = require(script.Parent.Parent.Parent.server.Services.M14_Parental)

	describe("M14_Parental — Consent", function()
		it("should grant consent", function()
			local record = M14:GrantConsent("user_test1", 99999, "hash_xyz")
			expect(record).to.be.a("table")
			expect(record.child_pid).to.equal("user_test1")
			expect(record.parent_user_id).to.equal(99999)
			expect(record.consent_given_at > 0).to.equal(true)
		end)

		it("should have consent for granted user", function()
			expect(M14:HasConsent("user_test1")).to.equal(true)
		end)

		it("should NOT have consent for ungranted user", function()
			expect(M14:HasConsent("user_never_consented")).to.equal(false)
		end)

		it("should revoke consent", function()
			local ok = M14:RevokeConsent("user_test1")
			expect(ok).to.equal(true)
			expect(M14:HasConsent("user_test1")).to.equal(false)
		end)

		it("should return false for revoke on unknown user", function()
			local ok = M14:RevokeConsent("user_nonexistent")
			expect(ok).to.equal(false)
		end)

		it("should set consent expiry date", function()
			M14:GrantConsent("user_expiry_test", 88888, nil)
			local record = M14:GetConsent("user_expiry_test")
			expect(record.expires_at > os.time()).to.equal(true)
		end)
	end)

	describe("M14_Parental — PlayTimeLimits", function()
		it("should set a limit", function()
			local ok = M14:SetPlayTimeLimit("user_kid", 60, true, 50)
			expect(ok).to.equal(true)
			local limit = M14:GetPlayTimeLimit("user_kid")
			expect(limit.max_minutes_per_day).to.equal(60)
			expect(limit.warning_at_minutes).to.equal(50)
		end)

		it("should reject negative limit", function()
			local ok = M14:SetPlayTimeLimit("user_bad", -10, true)
			expect(ok).to.equal(false)
		end)

		it("should allow play when no limit set", function()
			local allowed, played, warnAt = M14:CheckPlayTime({ UserId = 55555 })
			expect(allowed).to.equal(true)
			expect(played).to.equal(0)
			expect(warnAt).to.equal(nil)
		end)
	end)

	describe("M14_Parental — Privacy Requests (GDPR Art. 17/20)", function()
		it("should request data export", function()
			local req = M14:RequestDataExport("user_gdpr1")
			expect(req.request_type).to.equal("data_export")
			expect(req.executed).to.equal(false)
			-- 30-day grace period
			expect(req.execute_at > req.requested_at).to.equal(true)
		end)

		it("should request account deletion", function()
			local req = M14:RequestAccountDeletion("user_gdpr2")
			expect(req.request_type).to.equal("account_deletion")
		end)

		it("should cancel privacy request", function()
			M14:RequestAccountDeletion("user_gdpr3")
			local ok = M14:CancelPrivacyRequest("user_gdpr3")
			expect(ok).to.equal(true)
			expect(M14:GetPrivacyRequest("user_gdpr3")).to.equal(nil)
		end)

		it("should not cancel non-existent request", function()
			local ok = M14:CancelPrivacyRequest("user_unknown")
			expect(ok).to.equal(false)
		end)
	end)
end